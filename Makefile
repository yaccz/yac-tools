PREFIX ?=  /usr/local
BINDIR ?=  $(PREFIX)/bin
LIBDIR ?=  $(PREFIX)/lib


INSTALL_DIR ?= install -m 755 -d
INSTALL_BIN ?= install -m 755

BUILD_DIR = build

NAME=yt

build:

install:

	$(INSTALL_DIR) $(DESTDIR)$(BINDIR)
	$(INSTALL_BIN) ./bin/$(NAME) $(DESTDIR)$(BINDIR)/$(NAME)

	$(INSTALL_DIR) $(DESTDIR)$(LIBDIR)/$(NAME)
	$(INSTALL_DIR) $(DESTDIR)$(LIBDIR)/$(NAME)/commands
	cp -r ./src/commands $(DESTDIR)$(LIBDIR)/$(NAME)
