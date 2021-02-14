FROM golang:1.15-alpine as BASE_BUILD
ARG OUTLINE_SHADOWSOCKS_VERSION=
ARG ESSENTIAL_PACKAGES="git"

RUN set -e -x && \
    \
    echo "==> Install dependencies" && \
    apk --no-cache --update add ${ESSENTIAL_PACKAGES} && \
    \
    echo "==> Git clone and checkout ${OUTLINE_SHADOWSOCKS_VERSION} tag" && \
    cd /tmp/ && \
    git clone --depth=1 https://github.com/Jigsaw-Code/outline-ss-server outline && \
    cd outline && \
    git fetch --all --tags --prune && \
    git checkout "v${OUTLINE_SHADOWSOCKS_VERSION}" && \
    \
    env GO111MODULE=on CGO_ENABLED=0 GOOS=linux \
    go build -a -installsuffix cgo -ldflags="-s -w" -o /usr/local/bin/outline && \
    \
    echo "==> Cleaning up" && \
    apk del ${ESSENTIAL_PACKAGES} && \
    rm -rf /tmp/* /var/cache/apk

FROM gcr.io/distroless/static
COPY --from=BASE_BUILD /usr/local/bin/outline /usr/local/bin/outline
VOLUME ["/outline"]
ENTRYPOINT ["/usr/local/bin/outline"]
CMD ["-config", "/outline/config.yml", "-udptimeout", "5m0s", "--replay_history", "1000"]
