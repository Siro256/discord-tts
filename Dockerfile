FROM rust:1.63.0 as build-env
LABEL maintainer="yanorei32"

WORKDIR /usr/src

RUN cargo new discord-tts
COPY Cargo.toml Cargo.lock /usr/src/discord-tts/
WORKDIR /usr/src/discord-tts
RUN cargo build --release

COPY src/* /usr/src/discord-tts/src/
RUN touch src/* && cargo build --release

FROM debian:bullseye-20211220

WORKDIR /init
COPY init.sh /init/
RUN ./init.sh

WORKDIR /
RUN rm -rf /init

COPY --from=build-env \
	/usr/src/discord-tts/target/release/discord-tts \
	/usr/bin/discord-tts

VOLUME /var/discordtts/
CMD ["/usr/bin/discord-tts"]
