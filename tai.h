#ifndef TAI_H
#define TAI_H

/* also incorporates tai.h from qlogtools */

#include "uint64.h"

struct tai {
  uint64 x;
} ;

struct taichi
{
  unsigned long seconds;
  unsigned long nanoseconds;
};
typedef struct taichi tai;

#define tai_unix(t,u) ((void) ((t)->x = 4611686018427387914ULL + (uint64) (u)))

extern void tai_now();

#define tai_approx(t) ((double) ((t)->x))

extern void tai_add();
extern void tai_sub();
#define tai_less(t,u) ((t)->x < (u)->x)

#define TAI_PACK 8
extern void tai_pack();
extern void tai_unpack();

tai* tai64n_decode(const char* str, const char** endptr);
int tai64n_encode(const tai* t, char* buf);

tai* tai_decode(const char* str, const char** endptr);
int tai_encode(const tai* t, char* buf);

#endif
