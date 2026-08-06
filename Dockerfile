# Stage 1: Build dependencies (cached layer)
FROM ocaml/opam:alpine-ocaml-5.2 AS deps

WORKDIR /home/opam/app

# Install system deps
RUN sudo apk add --no-cache m4

# Install OCaml deps - this layer caches if deps don't change
RUN opam install -y -j4 --no-depexts ocamlfind ounit2

# Stage 2: Build the app
FROM ocaml/opam:alpine-ocaml-5.2 AS build

WORKDIR /home/opam/app

# Copy cached opam switch from deps stage
COPY --from=deps /home/opam/.opam /home/opam/.opam

# Install system deps
RUN sudo apk add --no-cache m4

COPY --chown=opam:opam . .
RUN opam exec -- make

# Stage 3: Runtime (minimal)
FROM alpine:3.20 AS runtime

WORKDIR /app

# Install runtime deps only (libc, etc.)
RUN apk add --no-cache libstdc++

COPY --from=build /home/opam/app/marina .

CMD ["./marina"]
