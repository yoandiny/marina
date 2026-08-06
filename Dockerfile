
FROM ocaml/opam:debian-ocaml-5.2

WORKDIR /app

COPY . .

RUN eval $(opam env) && make

CMD ["./marina"]
