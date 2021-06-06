FROM alpine:latest

WORKDIR /usr/local/

RUN apk update && \
    apk add --no-cache tzdata python3 runit py3-pip && \
    apk add --no-cache --virtual .build-deps git gcc linux-headers musl-dev python3-dev && \
    git clone --single-branch --branch master --depth=1 https://github.com/bxsang/v2-ui.git && \
    cd v2-ui && \
    chmod +x bin/xray-v2-ui-linux-amd64 /usr/local/v2-ui/v2-ui.sh && \
    python3 -m pip install --disable-pip-version-check --ignore-installed --no-cache-dir --quiet -r /usr/local/v2-ui/requirements.txt  && \
    apk del .build-deps git gcc linux-headers musl-dev python3-dev && \
    mkdir -p /etc/v2-ui/ && \
    mkdir -p /var/log/v2ray/ && \
    touch /etc/v2-ui/v2-ui.db && \
    touch /etc/v2-ui/v2-ui.log && \
    touch /var/log/v2ray/access.log && \
    touch /var/log/v2ray/error.log && \
    ln -sf /usr/local/v2-ui/v2-ui.sh /usr/bin/v2-ui.sh && \
    ln -sf /dev/stdout /etc/v2-ui/v2-ui.log && \
    ln -sf /dev/stdout /var/log/v2ray/access.log && \
    ln -sf /dev/stderr /var/log/v2ray/error.log

COPY runit /etc/service
CMD [ "runsvdir", "-P", "/etc/service"]
