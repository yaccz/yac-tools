.DEFAULT_GOAL := build

# common definitions
build_dir     = build
dist_dir      = dist
src_dir       = src

PREFIX       ?= /usr/local

sdist         = $(name).$(version)

## installation targets
i_bin_dir     = $(DESTDIR)$(PREFIX)/bin
i_man_dir     = $(DESTDIR)$(PREFIX)/man/man1

## build targets
b_bin_dir     = $(build_dir)/bin
b_man_dir     = $(build_dir)/man/man1


install_bin   = install -m755
install_data  = install -m644


# common program specific definitions
version   = 0.2.0
name      = yac-tools
sources   = GNUmakefile $(src_dir) README.rst

cmds      = $(patsubst $(src_dir)/%.zsh,%,$(wildcard $(src_dir)/*.zsh))
mans      = $(patsubst Documentation/man1/%.rst,%.1,$(wildcard Documentation/man1/*.rst))

dirs      =
dirs     += $(b_bin_dir) $(i_bin_dir)
dirs     += $(b_man_dir) $(i_man_dir)

## build dependencies
b_deps    =
b_deps   += $(b_bin_dir)
b_deps   += $(b_man_dir)
b_deps   += $(addprefix $(b_bin_dir)/,$(cmds))
b_deps   += $(addprefix $(b_man_dir)/,$(mans))

## install dependencies
i_deps    =
i_deps   += $(i_bin_dir)
i_deps   += $(i_man_dir)
i_deps   += $(addprefix $(i_bin_dir)/,$(cmds))
i_deps   += $(addprefix $(i_man_dir)/,$(mans))


# build
.PHONY: build
build: $(b_deps)


# install
.PHONY: install
install: $(i_deps)

.PHONY: install-home
install-home:

	$(MAKE) install PREFIX=$(HOME)/.local


# build binaries
$(b_bin_dir)/%: $(src_dir)/%.zsh

	$(install_bin) $< $@


# build man pages
$(b_man_dir)/%.1: Documentation/man1/%.rst

	rst2man $< $@


# install binaries
$(i_bin_dir)/%: $(b_bin_dir)/%

	$(install_bin) $< $@


# install man pages
$(i_man_dir)/%: $(b_man_dir)/%

	$(install_data) $< $@


# create directories
$(dirs):

	install -m755 -d $@


# source distribution archive
.PHONY: sdist
sdist:

	test ! -e $(dist_dir)/$(sdist)
	install -m700 -d $(dist_dir)/$(sdist)
	rsync -av $(sources) $(dist_dir)/$(sdist)
	cd $(dist_dir) && tar -cjf $(sdist).tar.bz2 $(sdist)


# tests
.PHONY: check
check:


# clean build/tests artefacts
.PHONY: clean
clean:

	$(RM) -r $(build_dir) $(dist_dir)
