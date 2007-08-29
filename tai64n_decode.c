#include "tai.h"

static int hex2int(char c) 
{
  if(c >= '0' && c <= '9')
    return c - '0';
  if(c >= 'A' && c <= 'F')
    return c - 'A' + 10;
  if(c >= 'a' && c <= 'f')
    return c - 'a' + 10;
  return -1;
}

tai* tai64n_decode(const char* str, const char** endptr)
{
  static struct taichi t;
  if(*str++ != '@')
    return 0;
  /* Check if the line is within range */
  if(str[0] != '4' || str[1] != '0' || str[2] != '0' || str[3] != '0' ||
     str[4] != '0' || str[5] != '0' || str[6] != '0' || str[7] != '0')
    return 0;
  t.seconds =
    hex2int(str[8]) << 28 |
    hex2int(str[9]) << 24 |
    hex2int(str[10]) << 20 |
    hex2int(str[11]) << 16 |
    hex2int(str[12]) << 12 |
    hex2int(str[13]) << 8 |
    hex2int(str[14]) << 4 |
    hex2int(str[15]);
  t.nanoseconds =
    hex2int(str[16]) << 28 |
    hex2int(str[17]) << 24 |
    hex2int(str[18]) << 20 |
    hex2int(str[19]) << 16 |
    hex2int(str[20]) << 12 |
    hex2int(str[21]) << 8 |
    hex2int(str[22]) << 4 |
    hex2int(str[23]);
  if(endptr)
    *endptr = str + 24;
  return &t;
}
