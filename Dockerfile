FROM ubuntu:22.04

ARG VERSION=stable

ENV FACTORIO_HOME=/factorio/

ENV WORLD_NAME=${WORLD_NAME:-lsdc2} \
    SERVER_PORT=${SERVER_PORT:-34197}

ENV LSDC2_SNIFF_IFACE="eth0" \
    LSDC2_SNIFF_FILTER="udp port $SERVER_PORT" \
    LSDC2_CWD=$FACTORIO_HOME \
    LSDC2_UID=1000 \
    LSDC2_GID=1000 \
    LSDC2_PERSIST_FILES="$WORLD_NAME.zip;server-settings.json" \
    LSDC2_ZIP=0 \
    LSDC2_ZIPFROM=$FACTORIO_HOME

WORKDIR $FACTORIO_HOME

ADD https://github.com/Meuna/lsdc2-serverwrap/releases/download/v0.1.0/serverwrap /serverwrap
ADD https://www.factorio.com/get-download/$VERSION/headless/linux64 /factorio.tar.xz

COPY start-server.sh server-settings.json $FACTORIO_HOME

RUN apt-get update && apt-get install -y xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o factorio \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -o --no-create-home factorio \
    && tar -xJf /factorio.tar.xz --directory=$FACTORIO_HOME/.. \
    && rm /factorio.tar.xz \
    && chmod u+x /serverwrap \
    && chown -R factorio:factorio $FACTORIO_HOME

EXPOSE 34197/udp
ENTRYPOINT ["/serverwrap"]
CMD ["./start-server.sh"]
