PREFIX ?=  /usr/local
BINDIR ?=  $(PREFIX)/bin
LIBDIR ?=  $(PREFIX)/lib


INSTALL_DIR ?= install -m 755 -d
INSTALL_BIN ?= install -m 755

BUILD_DIR = build

NAME=yt

COMM_DIR=$(DESTDIR)$(LIBDIR)/$(NAME)
COMMS=$(subst ./src/,,$(shell find ./src/commands -type f))
INSTALL_COMMS=$(addprefix $(DESTDIR)$(LIBDIR)/$(NAME)/,$(COMMS))
INSTALL_BIN_YT=$(DESTDIR)$(BINDIR)/$(NAME)

build:

install: $(INSTALL_COMMS) $(INSTALL_BIN_YT)

$(DESTDIR)/$(BINDIR):

	$(INSTALL_DIR) $(DESTDIR)$(BINDIR)

$(INSTALL_BIN_YT): $(DESTDIR)$(BINDIR) ./bin/$(NAME)

	$(INSTALL_BIN) ./bin/$(NAME) $(DESTDIR)$(BINDIR)/$(NAME)


$(INSTALL_COMMS): $(DESTDIR)$(LIBDIR)/$(NAME)
	$(INSTALL_BIN) -D ./src/$(subst $(DESTDIR)$(LIBDIR)/$(NAME)/,,$@) $@


$(DESTDIR)$(LIBDIR)/$(NAME):

	$(INSTALL_DIR) $(DESTDIR)$(LIBDIR)/$(NAME)/commands

uninstall:

	$(RM) $(INSTALL_BIN_YT)
	$(RM) -r $(COMM_DIR)
