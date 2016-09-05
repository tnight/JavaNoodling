/*
 *
 * Program: readdir.c
 *
 * Purpose: Test the opendir(), readdir(), etc. system functions in
 * the Cygwin environment.
 *
 * Created: 04/21/2003 by Terry Nightingale <terryn@trendwest.com>
 *
 * Changed: 99/99/9999 by ... to ...
 * 
 */

#include <dirent.h>
#include <stdio.h>
#include <sys/types.h>

#define THE_DIR "/tmp"

int main(int argc, char **argv)
{
  DIR *dir;
  struct dirent *dirent;

  dir = opendir(THE_DIR);
  if (dir == NULL) {
    fprintf(stderr, "Directory open failed.\n");
    exit(1);
    return(1);
  }


  while ((dirent = readdir(dir)) != NULL) {
    fprintf(stdout, "Next entry: [%s]\n", dirent->d_name);
  }

  closedir(dir);

  exit(0);
  return(0);
}
