FROM alpine
RUN apk add --no-cache \
    curl \
    bash \
    git \
    dumb-init \
    openssl

WORKDIR /app
ADD glider glider.conf entrypoint.sh ./

EXPOSE 15000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["/app/glider", "-config", "/app/glider.conf"]