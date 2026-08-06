FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app
COPY --chown=opam:opam . .
RUN opam exec -- ocamlc -custom -o marina str.cma \
      my.ml prop.ml sat_ifexpr.ml marina.ml main.ml

CMD ["./marina"]
