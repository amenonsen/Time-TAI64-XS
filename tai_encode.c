#include "tai.h"

int tai_encode(const tai* t, char* buf)
{
  unsigned long s = t->seconds;
  unsigned long n = t->nanoseconds;
  int i;
  for(i = 9; i >= 0; i--) {
    buf[i] = '0' + s % 10;
    s /= 10;
  }
  buf[10] = '.';
  for(i = 19; i >= 11; i--) {
    buf[i] = '0' + n % 10;
    n /= 10;
  }
  buf[20] = 0;
  return 1;
}
