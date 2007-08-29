#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <tai.h>
#include <caldate.h>
#include <caltime.h>
#include <leapsecs.h>
#include <taia.h>

#include "const-c.inc"

typedef struct caldate Caldate;
typedef struct caltime Caltime;
typedef struct tai TAI;
typedef struct taia TAIA;

MODULE = Time::TAI64		PACKAGE = Time::TAI64

PROTOTYPES: ENABLE

INCLUDE: const-xs.inc

long
caltime_offset(ct)
    Caltime *ct
    CODE:
	RETVAL = ct->offset;
    OUTPUT:
	RETVAL

Caldate *
caltime_date(ct)
    Caltime *ct
    CODE:
        New(0, RETVAL, 1, Caldate);
	RETVAL = &ct->date;
    OUTPUT:
	RETVAL

int
caltime_hour(ct)
    Caltime *ct
    CODE:
	RETVAL = ct->hour;
    OUTPUT:
	RETVAL

int
caltime_minute(ct)
    Caltime *ct
    CODE:
	RETVAL = ct->minute;
    OUTPUT:
	RETVAL

int
caltime_second(ct)
    Caltime *ct
    CODE:
	RETVAL = ct->second;
    OUTPUT:
	RETVAL

long
caldate_year(cd)
    Caldate *cd
    CODE:
	RETVAL = cd->year;
    OUTPUT:
	RETVAL

int
caldate_month(cd)
    Caldate *cd
    CODE:
	RETVAL = cd->month;
    OUTPUT:
	RETVAL


int
caldate_day(cd)
    Caldate *cd
    CODE:
	RETVAL = cd->day;
    OUTPUT:
	RETVAL

long
caldate_setyear(cd,x)
    Caldate *cd
    long x
    CODE:
	cd->year = x;
	RETVAL = x;
    OUTPUT:
	RETVAL

int
caldate_setmonth(cd,x)
    Caldate *cd
    int x
    CODE:
	cd->month = x;
	RETVAL = x;
    OUTPUT:
	RETVAL

int
caldate_setday(cd,x)
    Caldate *cd
    int x
    CODE:
	cd->day = x;
	RETVAL = x;
    OUTPUT:
	RETVAL

Caldate *
caldate_new(year, month, day)
	long year
	int month
	int day
    CODE:
        New(0, RETVAL, 1, Caldate);
	RETVAL->year = year;
	RETVAL->month = month;
	RETVAL->day = day;
    OUTPUT:
	RETVAL

char *
caldate_fmt(cd)
	Caldate *cd
    PREINIT:
        int len;
    CODE:
        len = caldate_fmt(0, cd);
	New(0, RETVAL, len+1, char);
	caldate_fmt(RETVAL, cd);
	*(RETVAL+len) = '\0';
    OUTPUT:
    	RETVAL

Caldate *
caldate_scan(s)
	char *s
    PREINIT:
        int r;
    CODE:
        New(0, RETVAL, 1, Caldate);
	r = caldate_scan(s, RETVAL);
        if (r == 0)
	    XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

long
caldate_mjd(cd)
	Caldate *cd

void
caldate_frommjd(day)
	long day
    PREINIT:
        Caldate *cd;
        int weekday;
	int yearday;
	SV *ret;
    PPCODE:
        ret = newSV(0);
        New(0, cd, 1, Caldate);
	sv_setref_pv(ret, "CaldatePtr", cd);
	caldate_frommjd(cd, day, &weekday, &yearday);
	XPUSHs( sv_2mortal ( ret ) );
	if (GIMME_V == G_ARRAY)
	{
	    XPUSHs( sv_2mortal (newSViv ( weekday )));
	    XPUSHs( sv_2mortal (newSViv ( yearday )));
	}

Caldate *
caldate_normalize(cd)
	Caldate *cd;
    CODE:
	New(0, RETVAL, 1, Caldate);
	Copy(cd, RETVAL, 1, Caldate);
	caldate_normalize(RETVAL);
    OUTPUT:
	RETVAL

Caldate *
caldate_easter(cd)
	Caldate *cd;
    CODE:
	New(0, RETVAL, 1, Caldate);
	Copy(cd, RETVAL, 1, Caldate);
	caldate_easter(RETVAL);
    OUTPUT:
	RETVAL



Caltime *
caltime_scan(s)
	char *s
    PREINIT:
	int r;
    CODE:
	New(0, RETVAL, 1, Caltime);
	r = caltime_scan(s, RETVAL);
        if (r == 0)
	    XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

char *
caltime_fmt(ct)
        Caltime *ct
    PREINIT:
        int len;
    CODE:
        len = caltime_fmt(0, ct);
	New(0, RETVAL, len+1, char);
	caltime_fmt(RETVAL, ct);
	*(RETVAL+len) = '\0';
    OUTPUT:
    	RETVAL

TAI *
caltime_tai(ct)
        Caltime *ct
    CODE:
        New(0, RETVAL, 1, TAI);
	caltime_tai(ct, RETVAL);
    OUTPUT:
	RETVAL

void
caltime_utc(t)
        TAI *t
    PREINIT:
        Caltime *ct;
        int weekday;
	int yearday;
	SV *ret;
    PPCODE:
        ret = newSV(0);
        New(0, ct, 1, Caltime);
	sv_setref_pv(ret, "CaltimePtr", ct);
	caltime_utc(ct, t, &weekday, &yearday);
	XPUSHs( sv_2mortal ( ret ) );
	if (GIMME_V == G_ARRAY)
	{
	    XPUSHs( sv_2mortal (newSViv ( weekday )));
	    XPUSHs( sv_2mortal (newSViv ( yearday )));
	}

TAI *
tai_now()
    CODE:
	New(0, RETVAL, 1, TAI);
	tai_now(RETVAL);
    OUTPUT:
	RETVAL

double
tai_approx(t)
    	TAI *t
    CODE:
        RETVAL = tai_approx(t);
    OUTPUT:
	RETVAL

TAI *
tai_add(u,v)
	TAI *u
	TAI *v
    CODE:
	New(0, RETVAL, 1, TAI);
	tai_add(RETVAL,u,v);
    OUTPUT:
	RETVAL

TAI *
tai_sub(u,v)
	TAI *u
	TAI *v
    CODE:
	New(0, RETVAL, 1, TAI);
	tai_sub(RETVAL,u,v);
    OUTPUT:
	RETVAL

void 
tai_less(t,u)
    	TAI *t
    	TAI *u
    PPCODE:
        if (tai_less(t,u)) {
	    XPUSHs( sv_2mortal( newSViv( 1 )));
	} else {
	    XSRETURN_UNDEF;
	}

void
tai_pack(t)
	TAI *t
    PREINIT:
        char *retval;
    PPCODE:

	/* We make retval ourselves since otherwise Perl
	 * assumes the length of the string is until the first
	 * zero. A faulty assumption in this case.
	 */

        New(0, retval, TAI_PACK+1, char);
	Zero(retval, TAI_PACK+1, char);
	tai_pack(retval, t);
	XPUSHs(sv_2mortal( newSVpv(retval, TAI_PACK) ));

TAI *
tai_unpack(s)
	char *s
    CODE:
        New(0, RETVAL, 1, TAI);
	Zero(RETVAL, 1, TAI);
	tai_unpack(s, RETVAL);
    OUTPUT:
	RETVAL

int
leapsecs_init()

int
leapsecs_read()

TAI *
leapsecs_add(t, hit)
        TAI *t
	int hit
    CODE:
        New(0, RETVAL, 1, TAI);
	Copy(t, RETVAL, 1, TAI);
	leapsecs_add(RETVAL, hit);
    OUTPUT:
	RETVAL

TAI *
leapsecs_sub(t)
        TAI *t
    PREINIT:
	int r;
    CODE:
        New(0, RETVAL, 1, TAI);
	Copy(t, RETVAL, 1, TAI);
	r = leapsecs_sub(RETVAL);
	if (r == 1)
	    XSRETURN_UNDEF;
    OUTPUT:
	RETVAL

TAI *
taia_tai(ta)
        TAIA *ta
    CODE:
        New(0, RETVAL, 1, TAI);
	taia_tai(ta, RETVAL);
    OUTPUT:
	RETVAL

TAIA *
taia_now()
    CODE:
        New(0, RETVAL, 1, TAIA);
	taia_now(RETVAL);
    OUTPUT:
	RETVAL

double
taia_approx(t)
	TAIA *t

double
taia_frac(t)
	TAIA *t

TAIA *
taia_add(u, v)
    	TAIA *u
	TAIA *v
    CODE:
        New(0, RETVAL, 1, TAIA);
	taia_add(RETVAL, u, v);
    OUTPUT:
	RETVAL

TAIA *
taia_sub(u, v)
    	TAIA *u
	TAIA *v
    CODE:
        New(0, RETVAL, 1, TAIA);
	taia_sub(RETVAL, u, v);
    OUTPUT:
	RETVAL

TAIA *
taia_half(u)
	TAIA *u
    CODE:
        New(0, RETVAL, 1, TAIA);
	taia_half(RETVAL, u);
    OUTPUT:
	RETVAL

void 
taia_less(t,u)
    	TAIA *t
    	TAIA *u
    PPCODE:
        if (taia_less(t,u)) {
	    XPUSHs( sv_2mortal( newSViv( 1 )));
	} else {
	    XSRETURN_UNDEF;
	}


char *
taia_pack(t)
	TAIA *t
    CODE:
        New(0, RETVAL, TAIA_PACK, char);
	taia_pack(RETVAL, t);
    OUTPUT:
	RETVAL

TAI *
taia_unpack(s)
	char *s
    CODE:
        New(0, RETVAL, 1, TAI);
	taia_unpack(s, RETVAL);
    OUTPUT:
	RETVAL

char *
taia_fmtfrac(t)
	TAIA *t
    CODE:
        New(0, RETVAL, TAIA_FMTFRAC + 1, char);
	RETVAL[taia_fmtfrac(RETVAL, t)] = 0;
    OUTPUT:
	RETVAL

