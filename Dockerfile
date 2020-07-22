FROM v2fly/v2fly-core:v4.26.0

WORKDIR /usr/local/

RUN apk update && \
    apk add --no-cache git tzdata python3 gcc linux-headers musl-dev python3-dev py3-pip runit && \
    git clone https://github.com/sola97/v2-ui.git && \
    cd v2-ui && \
    python3 -m pip install --disable-pip-version-check --ignore-installed --no-cache-dir -r requirements.txt

COPY runit /etc/service
CMD [ "runsvdir", "-P", "/etc/service"]