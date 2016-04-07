# Standard things which help keeping track of the current directory
# while include all Rules.mk.
d := $(if $(d),$(d)/,)$(mod)

BIBI_INCLUDES := -I $(d) $(PACK_BIBI)
BIBI_DEPS_INCLUDES := -I $(d) $(DEPS_PACK_BIBI)

# Finding dependencies
$(d)/%.ml.depends: INCLUDES += $(BIBI_DEPS_INCLUDES)
$(d)/%.cmo $(d)/%.cmi $(d)/%.cmx : INCLUDES:=$(BIBI_INCLUDES)

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),distclean)
-include $(d)/bibi.ml.depends
endif
endif

# Building stuff
BIBI_LIBS := $(d)/bibi.cmxa $(d)/bibi.cma
all: $(BIBI_LIBS)

$(d)/bibi.cmxa: %.cmxa: %.cmx
	$(ECHO) "[OPT]    $< -> $@"
	$(Q)$(OCAMLOPT) $(OFLAGS) $(INCLUDES) -o $@ -a $<

$(d)/bibi.p.cmxa: %.p.cmxa: %.p.cmx
	$(ECHO) "[OPT -p] $< -> $@"
	$(Q)$(OCAMLOPT) -p $(OFLAGS) $(INCLUDES) -o $@ -a $<

$(d)/bibi.cma: %.cma: %.cmo $(TYPOGRAPHY_DIR)/Typography.cma
	$(ECHO) "[OCAMLC] $< -> $@"
	$(Q)$(OCAMLC) $(OFLAGS) $(INCLUDES) -o $@ -a $<

$(d)/bibi.cmi: $(d)/bibi.cmo ;
$(d)/bibi.p.cmi: $(d)/bibi.cmi
	cp $< $@

# Installing
install: install-bibi
.PHONY: install-bibi
install-bibi: $(BIBI_LIBS) $(d)/bibi.a $(d)/bibi.cmi $(d)/META
	install -m 755 -d $(DESTDIR)/$(INSTALL_BIBI_DIR)
	install -m 644 $^ $(DESTDIR)/$(INSTALL_BIBI_DIR)

# Cleaning
CLEAN += $(d)/*.cm[aoix] $(d)/*.cmxa $(d)/*.a $(d)/*.o
DISTCLEAN += $(d)/*.depends

# Rolling back changes made at the top
d := $(patsubst %/,%,$(dir $(d)))
