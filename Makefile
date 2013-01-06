TOP:=$(dir $(lastword $(MAKEFILE_LIST)))

libdir:=/usr/lib/ydu

all:

install: installdirs
	cp -r $(TOP)/src/usr/bin/ydu $(DESTDIR)/usr/bin/
	cp -r $(TOP)/src/usr/lib/ydu/* $(DESTDIR)$(libdir)
	chmod og+rx $(DESTDIR)$(libdir) -R
	chmod og+rx $(DESTDIR)/usr/bin/ydu

installdirs:
	mkdir -p $(DESTDIR)$(libdir)

uninstall:
	rm $(DESTDIR)/usr/bin/ydu
	rm $(DESTDIR)$(libdir) -r
