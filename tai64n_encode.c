#include "tai.h"

static char INT2HEX[16] = "0123456789abcdef";
#define int2hex(X) INT2HEX[(X)&0xf]

int tai64n_encode(const tai* t, char* buf)
{
  unsigned long n = t->nanoseconds;
  unsigned long s = t->seconds;
  char* ptr = buf + 1+8+8+8+1;
  *--ptr = 0;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n); n >>= 4;
  *--ptr = int2hex(n);
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s); s >>= 4;
  *--ptr = int2hex(s);
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '0';
  *--ptr = '4';
  *--ptr = '@';
  return 1;
}
