#include <stdio.h>
#include <string>
#include "HelloPrinter.h"

HelloPrinter::HelloPrinter()
{
  count = 0;
}

string HelloPrinter::getHello()
{
  char buf[100];

  sprintf(buf, "Hello World [%d]", ++count);

  msg = buf;
  return msg;
}

HelloPrinter::~HelloPrinter()
{
}
