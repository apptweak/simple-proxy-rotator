ARG ALPINE_VERSION=3.20
FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE=
ARG CVS_REF=
LABEL org.opencontainers.image.title="Simple Proxy Rotator"
LABEL org.opencontainers.image.description="Simple http(s) forward Proxy Rotator using glider"
LABEL org.opencontainers.image.source="https://github.com/apptweak/simple-proxy-rotator"
LABEL org.opencontainers.image.url="https://github.com/apptweak/simple-proxy-rotator"
LABEL org.opencontainers.image.vendor="AppTweak"
LABEL org.opencontainers.image.version=${CVS_REF}
LABEL org.opencontainers.image.created=${BUILD_DATE}

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

HEALTHCHECK --interval=60s --timeout=30s --start-period=10s --retries=3 \
  CMD nc -z localhost 15000 || exit 1

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/glider", "-config", "/app/glider.conf"]
