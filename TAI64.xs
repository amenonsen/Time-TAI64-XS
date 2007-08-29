#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <time.h>

MODULE = Time::TAI64		PACKAGE = Time::TAI64		

PROTOTYPES: ENABLE

void
tai64n(str)
		char * str
		INIT:
		time_t secs;
		unsigned long nanosecs;
		unsigned long u;
		struct tm *t;
		char ch;
		int i;

		PPCODE:
		secs = 0;
		nanosecs = 0;
		for (i = 0; i < 24; i++) {
				ch = str[i];
				if (ch == 0) break;
				u = ch - '0';
				if (u >= 10) {
						u = ch - 'a';
						if (u >= 6) break;
						u += 10;
				}
				secs <<= 4;
				secs += nanosecs >> 28;
				nanosecs &= 0xfffffff;
				nanosecs <<= 4;
				nanosecs += u;
		}
		secs -= 4611686018427387914ULL;

		XPUSHs(sv_2mortal(newSVuv((unsigned int)secs)));
		XPUSHs(sv_2mortal(newSVuv((unsigned int)nanosecs)));

void
tai64nlocal(str)
		char * str
		INIT:
		time_t secs;
		unsigned long nanosecs;
		unsigned long u;
		struct tm *t;
		char ch;
		int i;

		PPCODE:
		secs = 0;
		nanosecs = 0;
		for (i = 0; i < 24; i++) {
				ch = str[i];
				if (ch == 0) break;
				u = ch - '0';
				if (u >= 10) {
						u = ch - 'a';
						if (u >= 6) break;
						u += 10;
				}
				secs <<= 4;
				secs += nanosecs >> 28;
				nanosecs &= 0xfffffff;
				nanosecs <<= 4;
				nanosecs += u;
		}
		secs -= 4611686018427387914ULL;

		t = localtime(&secs);

		XPUSHs(sv_2mortal(newSViv((int)(1900 + t->tm_year))));
		XPUSHs(sv_2mortal(newSViv((int)(1 + t->tm_mon))));
		XPUSHs(sv_2mortal(newSViv((int)(t->tm_mday))));
		XPUSHs(sv_2mortal(newSViv((int)(t->tm_hour))));
		XPUSHs(sv_2mortal(newSViv((int)(t->tm_min))));
		XPUSHs(sv_2mortal(newSViv((int)(t->tm_sec))));
		XPUSHs(sv_2mortal(newSVuv((unsigned int)nanosecs)));
