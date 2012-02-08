TOP:=$(dir $(lastword $(MAKEFILE_LIST)))

install:
	cp -r $(TOP)/src/usr/bin/ydu $(DESTDIR)/usr/bin/
	cp -r $(TOP)/src/usr/lib/ydu $(DESTDIR)/usr/lib/
