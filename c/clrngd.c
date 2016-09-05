/* clrngd.c version 1.0.0
   Pawel Krawczyk <kravietz at aba.krakow.pl>, August-November 2002.
   $Id: clrngd.c,v 1.1 2003/03/19 00:55:48 terryn Exp $

   Features:
   * collects randomness from PC mainboard quartz fluctuations
   * FIPS testing is performed on the randomness
   * the randomness is added to the random pool
   * if 5 continuous FIPS tests fail, the daemon exits
   * the entropy is read every 240 seconds feeding 2500 bytes
     at a time
   * when working, the daemon uses CPU quite intensively
   * the daemon sets it's priority to 20 (very low) automatically
   * when starting, the daemon will feed /dev/random with
     32 bytes of unchecked data and immediately starts to fill
     the buffer for real checking
   * the daemon needs to run as root user

   Usage:

   	clrngd [time]

	Where "time" is optional time in seconds between random
	reads. The minimum is 60 seconds.

   This program uses original Adam L. Young code posted to sci.crypt to
   make a working unix daemon. FIPS testing code taken from intel-rngd
   by Philipp Rumpf.

Original comments follow:

Generate truly random bytes: VonNeumannBytes() version 1.0
written by Adam L. Young, Copyright (c) 2002 Adam L. Young

July 27, 2002

This is the source file for VonNeumannBytes() which returns
a byte stream of random bytes. It is based on truerand()
of M. Blaze, and J. Lacy, D. Mitchell, and W. Schell [1], since it
assumes that the underlying motherboard has a cpu crystal
and real-time crystal and attempts to extract physical randomness
from fluctuations in their frequencies of oscillation. The
basic idea is to set a timer interrupt using an OS call with a 
call-back routine and add unity to an initially zero
counter ad infinitum until the interrupt occurs. The call-back
routine causes the infinite increment loop to terminate. The lower
order 16 bits of the counter are assumed to contain some true
randomness. The real-time crystal defines the time until
the timer interrupt occurs. The instruction speed determines
the number of increments to the counter in this time. The
theory behind truerand is that the randomness of this process
is reflected in the least significant bits of the counter
value.

Unlike truerand however, VonNeumannBytes() takes the further
step of passing this randomness through an algorithm devised by
John von Neumann [2] to remove any potential bias in the randomness.
Neumann's method for unbiasing a biased coin is used as follows.
Two timer interrupts are called to obtain two sets of 16 least
significant bits from the two counter values. The least
significant bits of each are used as a von Neumann trial, then the
two penultimate bits are used as a second trial, and so on.
In a trial, a 00 or 11 is disregarded. A 01 result is interpreted
as a random binary 0, and a 10 result is interpreted as
a binary 1. Let p_{i,j} denote the probability that a binary
1 occurs in the jth bit of the ith trial, where j = 0,1,...15
and i = 1,2,3,4,.... This code therefore makes the following
assumptions:

1) That the motherboard has separate timer and cpu clock
crystals.

2) That p_{i,j} = p_{i+1,j} for i = 1,3,5,7,... and
j = 0,1,2,...,15.

3) That for a non-negligible number of iterations i, where
i is contained in {1,3,5,7,....}, there exists a j
contained in {0,1,2,...,15} such that p_{i,j} is neither
overwhelming nor negligible (and hence that differences in
the crystal frequencies are capable of providing randomness
sufficiently often that is measurable in poly-time).


If the above hold, then this routine outputs truly random
byte sequences. Note that (2) essentially states that the
behavior of the 16 bit counter must be that same across pairs
of calls. For example, suppose that p_{i,15} = 1 for
i = 1,2,3,... In this case the random number generator will
never output a bit based on bit position j = 15.

Note that we would expect the bias to get worse as the
significance of the bit increases. Von Neumann's method is
used to correct the bias.


Acknowledgements:

I learned about truerand() during my Masters degree at Columbia
University in 1995 in a course taught by Matt Blaze. Jack
Lacy was an invited speaker who spoke about truerand(). I
have advocated its use ever since, and I hope that this work
is regarded as building on it in a positive way.


References:

[1] J.B. Lacy, D.P. Mitchell and W.M. Schell, "CryptoLib:
Cryptography in Software", Proceedings of UNIX Security
Symposium IV, USENIX Association, 1993.	

[2] J. von Neumann, "Various techniques for use in connection
with random digits", in von Neumann's Collected Works,
Pergamon, New York, 1963, pages 768-770.


Unfortunately there are those who would steal this without
attributing credit, and even those who would try to hold
me accountable for any errors. So, below is the license
agreement:

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

1. Redistributions of source code must retain the copyright notice,
   this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the
   distribution.

3. All advertising materials mentioning features or use of this
   software must display the following acknowledgement:  This product
   includes software developed by Adam L. Young.

THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

This routine was tested with FIPS140.c written by Greg Rose of
Qualcomm. It performs favorably when run. Please send comments,
suggestions, bug reports, and hate mail to ayoung@cs.columbia.edu
*/

#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <fcntl.h>
#include <stdlib.h>
#include <syslog.h>
#include <sys/time.h>
#include <stdio.h>
#include <string.h>
#include <linux/types.h>
#include <linux/random.h>
#include <errno.h>
#include <sys/time.h>
#include <sys/resource.h>

static int gQuit;

#define FIPS_THRESHOLD 2500
#define FIPS_FAILURES_MAX 5
static int poker[16], runs[12];
static int ones, rlength = -1, current_bit, longrun;

/*
 * rng_fips_test_store - store 8 bits of entropy in FIPS
 * 			 internal test data pool
 */
static void
rng_fips_test_store (int rng_data)
{
  int j;
  static int last_bit = 0;
  poker[rng_data >> 4]++;
  poker[rng_data & 15]++;

  /* Note in the loop below rlength is always one less than the actual
     run length. This makes things easier. */
  for (j = 7; j >= 0; j--)
    {
      ones += current_bit = (rng_data & 1 << j) >> j;
      if (current_bit != last_bit)
	{

	  /* If runlength is 1-6 count it in correct bucket. 0's go in
	     runs[0-5] 1's go in runs[6-11] hence the 6*current_bit below */
	  if (rlength < 5)
	    {
	      runs[rlength + (6 * current_bit)]++;
	    }
	  else
	    {
	      runs[5 + (6 * current_bit)]++;
	    }

	  /* Check if we just failed longrun test */
	  if (rlength >= 33)
	    longrun = 1;
	  rlength = 0;

	  /* flip the current run type */
	  last_bit = current_bit;
	}
      else
	{
	  rlength++;
	}
    }
}


/*
 * now that we have some data, run a FIPS test
 */
static int
rng_run_fips_test (unsigned char *buf)
{
  int i, j;
  int rng_test = 0;
  for (i = 0; i < FIPS_THRESHOLD; i++)
    {
      rng_fips_test_store (buf[i]);
    }

  /* add in the last (possibly incomplete) run */
  if (rlength < 5)
    runs[rlength + (6 * current_bit)]++;

  else
    {
      runs[5 + (6 * current_bit)]++;
      if (rlength >= 33)
	rng_test |= 8;
    }
  if (longrun)
    {
      rng_test |= 8;
      longrun = 0;
    }

  /* Ones test */
  if ((ones >= 10346) || (ones <= 9654))
    rng_test |= 1;

  /* Poker calcs */
  for (i = 0, j = 0; i < 16; i++)
    j += poker[i] * poker[i];
  if ((j >= 1580457) || (j <= 1562821))
    rng_test |= 2;
  if ((runs[0] < 2267) || (runs[0] > 2733) ||
      (runs[1] < 1079) || (runs[1] > 1421) ||
      (runs[2] < 502) || (runs[2] > 748) ||
      (runs[3] < 223) || (runs[3] > 402) ||
      (runs[4] < 90) || (runs[4] > 223) ||
      (runs[5] < 90) || (runs[5] > 223) ||
      (runs[6] < 2267) || (runs[6] > 2733) ||
      (runs[7] < 1079) || (runs[7] > 1421) ||
      (runs[8] < 502) || (runs[8] > 748) ||
      (runs[9] < 223) || (runs[9] > 402) ||
      (runs[10] < 90) || (runs[10] > 223) ||
      (runs[11] < 90) || (runs[11] > 223))
    {
      rng_test |= 4;
    }
  rng_test = !rng_test;

  /* finally, clear out FIPS variables for start of next run */
  memset (poker, 0, sizeof (poker));
  memset (runs, 0, sizeof (runs));
  ones = 0;
  rlength = -1;
  current_bit = 0;
  return rng_test;
}
int VonNeumannBytes (unsigned char *buff, unsigned int bufflen);

/* VonNeumannBytes() fills the buffer buff with
bufflen truly random bytes. It returns 0 on success and -1
on failure. */
static void
interrupt ()
{
  gQuit = 1;
}
static unsigned int
ReturnPhysical2Bytes (void)
{
  struct itimerval it, oit;
  register unsigned long count;
  timerclear (&it.it_interval);
  it.it_value.tv_sec = 0;
  it.it_value.tv_usec = 15666;
  if (setitimer (ITIMER_REAL, &it, &oit) < 0)
    perror ("setitimer error occured");
  signal (SIGALRM, interrupt);
  count = 0;
  while (!gQuit)
    count++;
  gQuit = 0;
  return count % 0xFFFF;
}
static unsigned int
VonNeumann2Bytes (void)
{
  register unsigned char i, numbitsobtained = 0, toss1, toss2;
  register unsigned int bytes1, bytes2, retval = 0;

/* extract 16 bits at a time from crystals per alarm interrupt. */
  for (;;)

    {
      bytes1 = ReturnPhysical2Bytes ();
      bytes2 = ReturnPhysical2Bytes ();
      for (i = 0; i < 16; i++)

	{
	  toss1 = bytes1 % 2;
	  toss2 = bytes2 % 2;
	  if (toss1 != toss2)

	    {
	      retval = retval | toss1;
	      numbitsobtained++;
	      if (numbitsobtained == 16)
		goto EndVonNeumann2Bytes;
	      retval <<= 1;
	    }
	  bytes1 >>= 1;
	  bytes2 >>= 1;
	}
    }
EndVonNeumann2Bytes:return retval;
}

int
VonNeumannBytes (unsigned char *buff, unsigned int bufflen)
{
  register unsigned char isodd;
  register unsigned int i, localbufflen, twobytes;

/* VonNeumannBytes() fills the buffer buff with
bufflen truly random bytes. It returns 0 on success and -1
on failure. */
  if ((!bufflen) || (!buff))
    return -1;
  isodd = bufflen % 2;
  localbufflen = bufflen - isodd;
  for (i = 0; i < localbufflen;)

    {
      twobytes = VonNeumann2Bytes ();
      buff[i] = twobytes % 0xFF;
      twobytes >> 8;
      i++;
      buff[i] = twobytes;
      i++;
    }
  if (isodd)
    buff[i] = VonNeumann2Bytes () % 0xFF;
  return 0;
}

int
main (int argc, char **argv)
{
  unsigned char buff[FIPS_THRESHOLD];
  int rand_fd = -1;
  int fips = -1;
  int r = -1;
  unsigned long frequency = 240; /* how often to run, seconds */
  unsigned int fips_failures = 0; /* how many times FIPS has failed */
  struct
  {
    int ent_count;
    int size;
    unsigned char data[FIPS_THRESHOLD];
  }
  entropy;

  if(argc == 2) {
	  frequency = atol(argv[1]);
  }
  if(frequency < 240)
	  frequency = 240;

  entropy.ent_count = FIPS_THRESHOLD * 8;
  entropy.size = FIPS_THRESHOLD;

  setpriority(PRIO_PROCESS, 0, 20);

  rand_fd = open ("/dev/random", O_WRONLY);
  if (rand_fd < 0)
    {
      fprintf (stderr, "unable to open random device, exit: %s",
	       strerror (errno));
      return 1;
    }

  openlog ("clrngd", LOG_CONS | LOG_PID, LOG_DAEMON);

  /* First we feed /dev/random with small unchecked data
   * as a yet additional help for the fresh system
   * after reboot. This is BLOCKING operation, i.e. the daemon
   * will go into background AFTER feeding the bytes.
   */

#define INITIAL_BYTES	32
  VonNeumannBytes (entropy.data, INITIAL_BYTES);
  entropy.ent_count = INITIAL_BYTES * 8;
  entropy.size = INITIAL_BYTES;
  r = ioctl (rand_fd, RNDADDENTROPY, &entropy);
  if(r == 0) {
	  syslog(LOG_INFO, "fed %d entropy bytes", INITIAL_BYTES);
  }
  close(rand_fd);

  if (daemon (0, 0) < 0)
    {
      fprintf (stderr, "unable to daemonize, exit: %s", strerror (errno));
      return 1;
    }
  close(3);

  syslog(LOG_INFO, "clrngd daemon started");

  entropy.ent_count = FIPS_THRESHOLD * 8;
  entropy.size = FIPS_THRESHOLD;

  while (1)
    {
      VonNeumannBytes (entropy.data, FIPS_THRESHOLD);
      fips = rng_run_fips_test (entropy.data);
      if (!fips)
	{
	  syslog (LOG_ERR, "FIPS test failed.");
	  fips_failures++;
	  if( fips_failures > FIPS_FAILURES_MAX) {
		syslog(LOG_ERR, "Too many FIPS tests failed, apparently "
				"crystals do not provide any entropy.");
		syslog(LOG_ERR, "Exiting.");
		exit(1);
	  }
	  sleep (1);
	  continue;
	} else {
	  fips_failures = 0;
	}
      rand_fd = open ("/dev/random", O_WRONLY);
      if(rand_fd < 0) {
	      syslog(LOG_ERR, "open random failed: %s",
			      strerror(errno));
	      return(1);
      }
      syslog(LOG_INFO, "feeding %d entropy bytes", FIPS_THRESHOLD);
      r = ioctl (rand_fd, RNDADDENTROPY, &entropy);
      if (r != 0)
	{
	  syslog (LOG_ERR, "add entropy failed: %d", r);
	  r = write (rand_fd, &entropy.data, FIPS_THRESHOLD);
	  if (r < 0)
	    {
	      syslog (LOG_ERR, "write entropy failed: %s", strerror (errno));
	    }
	}
      close(rand_fd);
      sleep(frequency);
    }				/* main loop end */
}
