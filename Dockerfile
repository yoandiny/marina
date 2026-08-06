FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app
COPY --chown=opam:opam . .
RUN opam exec -- make

CMD ["./marina"]
