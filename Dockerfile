FROM ubuntu:22.04

ENV VERSION=stable \
    WORLD_NAME=lsdc2 \
    PASSWORD=factorio \
    FACTORIO_HOME=/factorio/

ENV VERSION_URL=https://www.factorio.com/get-download/$VERSION/headless/linux64 \
    WORLD_NAME=lsdc2 \
    SERVER_PORT=34197

ENV LSDC2_SNIFF_IFACE="eth0" \
    LSDC2_SNIFF_FILTER="udp port $SERVER_PORT" \
    LSDC2_CWD=$FACTORIO_HOME \
    LSDC2_UID=1000 \
    LSDC2_GID=1000 \
    LSDC2_PERSIST_FILES="$WORLD_NAME.zip" \
    LSDC2_ZIP=0 \
    LSDC2_ZIPFROM=$FACTORIO_HOME

WORKDIR $FACTORIO_HOME

ADD https://github.com/Meuna/lsdc2-serverwrap/releases/download/v0.2.0/serverwrap /serverwrap

COPY start-server.sh server-settings.json $FACTORIO_HOME

RUN apt-get update && apt-get install -y curl jq xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o factorio \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -d $FACTORIO_HOME -o --no-create-home factorio \
    && chown -R factorio:factorio $FACTORIO_HOME \
    && chmod u+x /serverwrap start-server.sh

EXPOSE 34197/udp
ENTRYPOINT ["/serverwrap"]
CMD ["./start-server.sh"]
