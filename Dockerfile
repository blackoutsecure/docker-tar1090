# syntax=docker/dockerfile:1.7

ARG BASE_IMAGE_REGISTRY=ghcr.io
ARG BASE_IMAGE_NAME=linuxserver/baseimage-alpine
ARG BASE_IMAGE_VARIANT=3.22
ARG BASE_IMAGE=${BASE_IMAGE_REGISTRY}/${BASE_IMAGE_NAME}:${BASE_IMAGE_VARIANT}
ARG BUILD_OUTPUT_DIR=/out
ARG TAR1090_REPO_URL=https://github.com/wiedehopf/tar1090
ARG TAR1090_REPO_BRANCH=master
ARG TAR1090_DB_URL=https://github.com/wiedehopf/tar1090-db/raw/csv/aircraft.csv.gz
ARG VCS_URL=https://github.com/blackoutsecure/docker-tar1090

FROM ${BASE_IMAGE} AS builder

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG BUILD_OUTPUT_DIR
ARG TAR1090_REPO_URL
ARG TAR1090_REPO_BRANCH
ARG TAR1090_DB_URL
ARG VCS_URL

RUN apk add --no-cache \
        bash \
        ca-certificates \
        curl \
        git \
        nginx \
        rsync \
        wget

WORKDIR /src

RUN git clone --branch ${TAR1090_REPO_BRANCH} --single-branch --depth 1 ${TAR1090_REPO_URL} . && \
    BUILD_DATE="$(git log -1 --format=%cI)" && \
    VERSION="$(git rev-parse --short HEAD)" && \
    VCS_REF="$(git rev-parse HEAD)" && \
    printf 'BUILD_DATE=%s\nVERSION=%s\nVCS_REF=%s\nVCS_URL=%s\n' "${BUILD_DATE}" "${VERSION}" "${VCS_REF}" "${VCS_URL}" > /tmp/tar1090-build-metadata.env && \
    rm -rf .git && \
    mkdir -p "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090" \
             "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090/html" \
             "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090/data" && \
    rsync -a --delete html/ "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090/html/" && \
    wget -q --https-only --tries=3 --timeout=20 -O "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090/data/aircraft.csv.gz" "${TAR1090_DB_URL}" && \
    install -D -m 0644 /tmp/tar1090-build-metadata.env "${BUILD_OUTPUT_DIR}/usr/local/share/tar1090/build-metadata.env"

FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG TAR1090_USER=abc
ARG TAR1090_PORT=8080
ARG TAR1090_SOURCE_DIR=/data/readsb
ARG TAR1090_WEBROOT=/usr/local/share/tar1090/html
ARG VCS_URL

LABEL build_version="Linuxserver.io version:- unknown Build-date:- unknown"
LABEL maintainer="Blackout Secure - https://blackoutsecure.app/"
LABEL org.opencontainers.image.title="docker-tar1090" \
    org.opencontainers.image.description="LinuxServer.io style containerized tar1090 web UI that serves aircraft visualization data from a mounted readsb or dump1090 JSON directory." \
    org.opencontainers.image.url="${VCS_URL}" \
    org.opencontainers.image.source="${VCS_URL}" \
    org.opencontainers.image.revision="unknown" \
    org.opencontainers.image.created="unknown" \
    org.opencontainers.image.version="unknown" \
    org.opencontainers.image.licenses="GPL-3.0-or-later"

ENV HOME="/config" \
    TAR1090_USER="${TAR1090_USER}" \
    TAR1090_PORT="${TAR1090_PORT}" \
    TAR1090_SOURCE_DIR="${TAR1090_SOURCE_DIR}" \
    TAR1090_WEBROOT="${TAR1090_WEBROOT}"

RUN apk add --no-cache \
        bash \
        nginx \
        tar \
        tzdata

COPY --link --from=builder /out/usr/local/share/tar1090/ /usr/local/share/tar1090/
COPY --link root/ /

RUN if [ -f /usr/local/share/tar1090/build-metadata.env ]; then . /usr/local/share/tar1090/build-metadata.env; fi && \
    echo "Linuxserver.io version:- ${VERSION:-unknown} Build-date:- ${BUILD_DATE:-unknown} Revision:- ${VCS_REF:-unknown}" > /build_version && \
    find /etc/s6-overlay/s6-rc.d -type f \( -name run -o -name finish -o -name check \) -exec chmod 0755 {} + && \
    mkdir -p /config /data/readsb && \
    chown -R 911:911 /config /usr/local/share/tar1090 && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD sh -c 'wget -q --spider http://127.0.0.1:${TAR1090_PORT:-8080}/ || exit 1'

EXPOSE 8080
VOLUME ["/config"]
