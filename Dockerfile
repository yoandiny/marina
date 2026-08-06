FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app
COPY --chown=opam:opam . .
RUN opam exec -- sh -c '\
  set -e; \
  for m in my prop sat_ifexpr marina; do ocamlc -c "$m.mli" "$m.ml"; done; \
  ocamlc -c main.ml; \
  ocamlc -custom -o marina str.cma my.cmo prop.cmo sat_ifexpr.cmo marina.cmo main.cmo'

CMD ["./marina"]
