FROM alpine:3.20
LABEL org.opencontainers.image.source https://github.com/apptweak/simple-proxy-rotator
RUN apk add --no-cache \
    openssl \
    curl \
    bash \
    git \
    dumb-init

# Make sure to use bash with pipefail in case something
# fails while being piped to another command in the docker-build
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

WORKDIR /app
COPY glider glider.conf entrypoint.sh ./

EXPOSE 15000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/glider", "-config", "/app/glider.conf"]
