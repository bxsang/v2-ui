FROM v2fly/v2fly-core:v4.26.0

WORKDIR /usr/local/

RUN apk update && \
    apk add --no-cache tzdata python3 runit && \
    apk add --no-cache --virtual .build-deps git gcc linux-headers musl-dev python3-dev py3-pip && \
    git clone https://github.com/sola97/v2-ui.git && \
    cd v2-ui && \
    python3 -m pip install --disable-pip-version-check --ignore-installed --no-cache-dir -r requirements.txt && \
    apk del .build-deps git gcc linux-headers musl-dev python3-dev py3-pip && \
    mkdir -p /etc/v2-ui/ && \
    mkdir -p /var/log/v2ray/ && \
    touch /etc/v2-ui/v2-ui.log && \
    touch /var/log/v2ray/access.log && \
    touch /var/log/v2ray/error.log && \
    ln -sf /dev/stdout /etc/v2-ui/v2-ui.log && \
    ln -sf /dev/stdout /var/log/v2ray/access.log && \
    ln -sf /dev/stderr /var/log/v2ray/error.log

COPY runit /etc/service
CMD [ "runsvdir", "-P", "/etc/service"]
