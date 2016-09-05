/*
 *
 * Program: printf.c
 *
 * Purpose: Test the printf() system function with dynamic formats. 
 *
 * Created: 05/25/2001 by Terry Nightingale
 *
 * Changed: 99/99/9999 by ... to ...
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main(int argc, char **argv)
{
    int size;
    char format[100];
    char foobar[100];

    printf("Enter the width: ");
    scanf("%d", &size);

    sprintf(format, "[%%%ds]\n", size);

    printf(format, "abc");
}
