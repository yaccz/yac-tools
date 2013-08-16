TOP:=$(dir $(lastword $(MAKEFILE_LIST)))

libdir:=/usr/lib/ydu
bindir:=/usr/bin

all:

install: installdirs
	cp -r $(TOP)/src/usr/bin/ydu $(DESTDIR)$(bindir)
	cp -r $(TOP)/src/usr/lib/ydu/* $(DESTDIR)$(libdir)
	chmod og+rx $(DESTDIR)$(libdir) -R
	chmod og+rx $(DESTDIR)$(bindir)/ydu

installdirs:
	mkdir -p $(DESTDIR)$(libdir)
	mkdir -p $(DESTDIR)$(bindir)

uninstall:
	rm $(DESTDIR)$(bindir)/ydu
	rm $(DESTDIR)$(libdir) -r
