/*
 *
 * Program: lock.c
 *
 * Purpose: Test the fcntl(), flock(), and lockf() system functions on
 * AIX, Linux, and Windows.
 *
 * Created: 03/13/2002 by Terry Nightingale
 *
 * Changed: 99/99/9999 by ... to ...
 *
 */

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>

void die(const char *msg, int returnCode)
{
  fprintf(stderr, msg);
  exit(returnCode);
}

int main(int argc, char **argv)
{
  const char *path = "/tmp/lock.lock";
  const int flags = O_CREAT | O_RDONLY;
  char msg[100];
  int fd;
  int result;

  fd = open(path, flags);
  if (fd == 0) {
    sprintf(msg, "fopen() failed: error number %d.\n", errno);
    die(msg, 1);
  }

  result = lockf(fd, F_LOCK, 0);
  printf("After lockf(), result = [%d].\n", result);

  exit(0);
}

