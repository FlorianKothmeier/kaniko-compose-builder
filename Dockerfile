# build rust app and copy it into the kaniko container

FROM ekidd/rust-musl-builder AS build
WORKDIR /tmp
COPY Cargo.toml .
RUN mkdir -p src/bin
RUN echo "fn main(){}" > src/bin/dependency-dummy.rs
RUN cargo build --release

COPY src src
RUN cargo build --release
RUN strip /tmp/target/x86_64-unknown-linux-musl/release/kaniko-compose-builder

FROM gcr.io/kaniko-project/executor:v1.15.0
COPY --from=build /tmp/target/x86_64-unknown-linux-musl/release/kaniko-compose-builder /usr/local/bin/
ENTRYPOINT []
