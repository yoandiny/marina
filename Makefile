SOURCES = my.ml prop.ml sat_ifexpr.ml marina.ml main.ml
EXEC = marina

CAMLC = ocamlc
CAMLDEP = ocamldep
CAMLDOC = ocamldoc

LIBS = str.cma
CUSTOM = -custom

all: $(EXEC)

OBJS = my.cmo prop.cmo sat_ifexpr.cmo marina.cmo main.cmo

$(EXEC): $(OBJS)
	$(CAMLC) $(CUSTOM) -o $(EXEC) $(LIBS) $(OBJS)

.SUFFIXES: .ml .mli .cmo .cmi

# Explicit .cmi deps: without them, a missing .depend compiles .ml before interfaces.
my.cmi: my.mli
	$(CAMLC) -c $<
prop.cmi: prop.mli
	$(CAMLC) -c $<
sat_ifexpr.cmi: sat_ifexpr.mli
	$(CAMLC) -c $<
marina.cmi: marina.mli
	$(CAMLC) -c $<

my.cmo: my.ml my.cmi
	$(CAMLC) -c my.ml
prop.cmo: prop.ml prop.cmi my.cmi
	$(CAMLC) -c prop.ml
sat_ifexpr.cmo: sat_ifexpr.ml sat_ifexpr.cmi prop.cmi my.cmi
	$(CAMLC) -c sat_ifexpr.ml
marina.cmo: marina.ml marina.cmi sat_ifexpr.cmi prop.cmi my.cmi
	$(CAMLC) -c marina.ml
main.cmo: main.ml marina.cmi
	$(CAMLC) -c main.ml

doc: all
	mkdir -p doc
	rm -rf doc/*
	$(CAMLDOC) -d doc/ -html *.mli

clean:
	rm -f *.cm[io] *~ .*~ #*#
	rm -f $(EXEC)
	rm -rf doc
	rm -f .depend

test:
	ocamlfind ocamlc -package ounit2 -linkpkg -o test str.cma my.ml prop.ml sat_ifexpr.ml marina.ml test.ml
	./test

.depend: $(SOURCES)
	$(CAMLDEP) *.mli *.ml > .depend

depend: $(SOURCES)
	$(CAMLDEP) *.mli *.ml > .depend

-include .depend
