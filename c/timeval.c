/*
 *
 * Program: timeval.c
 *
 * Purpose: Test the gettimeofday() system function on AIX. 
 *
 * Created: 01/12/2000 by Terry Nightingale <tnight@ironworx.com>
 *
 * Changed: 10/03/2001 by Terry Nightingale to display the current
 * time in milliseconds since the epoch.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main(int argc, char **argv)
{
  struct timeval  *Tp;
  struct timezone *Tzp = NULL;
  int returnVal;

  Tp = malloc(sizeof(*Tp));
  if (Tp == NULL)
  {
    fprintf(stderr, "malloc() failed, exiting.\n");
    exit(1);
    return(1);
  }

  returnVal = gettimeofday(Tp, Tzp);

  printf("After gettimeofday, returnVal = [%d],\n", returnVal);
  printf("    Tp->tv_sec = [%d],\n    Tp->tv_usec = [%ld].\n", 
      Tp->tv_sec, Tp->tv_usec);

  printf("Current time in milliseconds: [%f]\n", 
      (double)((Tp->tv_sec * 1000.0) + (Tp->tv_usec / 1000)));

  free(Tp);
  exit(0);
  return(0);
}
