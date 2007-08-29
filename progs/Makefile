OBJECTS = check easter leapsecs nowutc tai2tai64n tai64n2tai yearcal

all: $(OBJECTS)

COMPILE = $(CC) -I.. -o $@ $@.c ../[^T]*.o

leapsecs: leapsecs.c
	$(COMPILE)
check: check.c
	$(COMPILE)
nowutc: nowutc.c
	$(COMPILE)
tai2tai64n: tai2tai64n.c
	$(COMPILE)
tai64n2tai: tai64n2tai.c
	$(COMPILE)
yearcal: yearcal.c
	$(COMPILE)
easter: easter.c
	$(COMPILE)

clean:
	rm -f $(OBJECTS)
