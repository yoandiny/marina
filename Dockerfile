FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       ocaml-nox \
       gcc \
       libc6-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .
RUN set -e; \
    for m in my prop sat_ifexpr marina; do ocamlc -c "$m.mli" "$m.ml"; done; \
    ocamlc -c main.ml; \
    ocamlc -custom -o marina str.cma my.cmo prop.cmo sat_ifexpr.cmo marina.cmo main.cmo

CMD ["./marina"]
