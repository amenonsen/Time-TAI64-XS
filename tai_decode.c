#include "tai.h"

static int isdigit(char ch)
{
  return ch >= '0' && ch <= '9';
}

tai* tai_decode(const char* str, const char** endptr)
{
  static tai t;
  t.seconds = 0;
  t.nanoseconds = 0;
  while(isdigit(*str))
    t.seconds = (t.seconds * 10) + (*str++ - '0');
  if(*str == '.') {
    ++str;
    while(isdigit(*str))
      t.nanoseconds = (t.nanoseconds * 10) + (*str++ - '0');
  }
  if(endptr)
    *endptr = str;
  return &t;
}
