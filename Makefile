# rwm - reinforced window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c rwm.c util.c
OBJ = ${SRC:.c=.o}

all: rwm 

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

rwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f rwm ${OBJ} rwm-${VERSION}.tar.gz

dist: clean
	mkdir -p rwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		rwm.1 drw.h util.h ${SRC} rwm.png transient.c rwm-${VERSION}
	tar -cf rwm-${VERSION}.tar rwm-${VERSION}
	gzip rwm-${VERSION}.tar
	rm -rf rwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f rwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/rwm
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < rwm.1 > ${DESTDIR}${MANPREFIX}/man1/rwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/rwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/rwm\
		${DESTDIR}${MANPREFIX}/man1/rwm.1

.PHONY: all clean dist install uninstall
