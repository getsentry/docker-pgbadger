FROM alpine:3.12

ENV PGBADGER_VERSION 9.1
ENV PGBADGER_DOWNLOAD_URL https://github.com/darold/pgbadger/archive/v9.1.tar.gz
ENV PGBADGER_DOWNLOAD_SHA256 2fd7166d74692cc7d87f00b37cc5c7c1c6eddf156372376d382a40f67d694011

RUN set -x \
        && apk add --no-cache --virtual .fetch-deps \
            ca-certificates \
            openssl \
            tar \
        && apk add --no-cache --virtual .build-deps \
            make \
        && apk add --no-cache --virtual .runtime-deps \
            perl \
            openssh-client \
        && wget -O pgbadger.tar.gz "$PGBADGER_DOWNLOAD_URL" \
        && echo "$PGBADGER_DOWNLOAD_SHA256 *pgbadger.tar.gz" | sha256sum -c - \
        && mkdir -p /usr/src/pgbadger \
        && tar -xzf pgbadger.tar.gz -C /usr/src/pgbadger --strip-components=1 \
        && rm pgbadger.tar.gz \
        && cd /usr/src/pgbadger \
        && perl Makefile.PL \
        && make \
        && make install \
        && rm -r /usr/src/pgbadger \
        && apk del .fetch-deps .build-deps

ENTRYPOINT ["pgbadger"]
