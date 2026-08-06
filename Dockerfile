FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app
COPY --chown=opam:opam . .
RUN eval $(opam env) && make

CMD ["./marina"]
