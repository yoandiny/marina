FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app

# Install system deps if needed (ocamlfind for Makefile test target)
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    m4 \
    && rm -rf /var/lib/apt/lists/*

# Install ocamlfind and ounit2 (used in Makefile test target)
RUN opam install -y ocamlfind ounit2

COPY --chown=opam:opam . .
RUN opam exec -- make

CMD ["./marina"]
