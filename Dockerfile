FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /home/opam/app

# Install system deps (m4 requis par certains paquets OPAM)
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    m4 \
    && rm -rf /var/lib/apt/lists/*

# Install OCaml deps used by Makefile (ocamlfind + ounit2 pour les tests)
# -j4 = 4 jobs parallèles pour accélérer la compilation
# --no-depexts = on a déjà installé m4 via apt
RUN opam install -y -j4 --no-depexts ocamlfind ounit2

COPY --chown=opam:opam . .
RUN opam exec -- make

CMD ["./marina"]
