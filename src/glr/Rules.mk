# Standard things which help keeping track of the current directory
# while include all Rules.mk.
d := $(if $(d),$(d)/,)$(mod)

all: $(d)/pa_ocaml $(d)/glr.cmxa $(d)/glr.cma

$(d)/pa_ocaml:
	$(MAKE) -e -C $(GLR_DIR) pa_ocaml
$(d)/glr.cmxa:
	$(MAKE) -e -C $(GLR_DIR) glr.cmxa
$(d)/glr.cma:
	$(MAKE) -e -C $(GLR_DIR) glr.cma

clean: clean-glr

clean-glr:
	$(MAKE) -e -C $(GLR_DIR) clean

$(d)/glr.a: $(d)/glr.cmxa;

install: install-glr

install-glr: export LIBDIR := $(INSTALL_GLR_DIR)

install-glr:
	$(MAKE) -C $(GLR_DIR) install

# Rolling back changes made at the top
d := $(patsubst %/,%,$(dir $(d)))
