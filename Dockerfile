FROM ubuntu:22.04

ENV LSDC2_USER=lsdc2 \
    LSDC2_HOME=/lsdc2 \
    LSDC2_UID=2000 \
    LSDC2_GID=2000

WORKDIR $LSDC2_HOME

RUN apt-get update && apt-get install -y curl xz-utils ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g $LSDC2_GID -o $LSDC2_USER \
    && useradd -g $LSDC2_GID -u $LSDC2_UID -d $LSDC2_HOME -o --no-create-home $LSDC2_USER \
    && chown -R $LSDC2_USER:$LSDC2_USER $LSDC2_HOME

ADD https://github.com/Meuna/lsdc2-serverwrap/releases/download/v0.4.4/serverwrap /usr/local/bin
COPY start-server.sh $LSDC2_HOME
RUN chown $LSDC2_USER:$LSDC2_USER start-server.sh \
    && chmod +x /usr/local/bin/serverwrap start-server.sh

ENV GAME_SAVENAME=lsdc2 \
    GAME_PORT=34197

ENV LSDC2_SNIFF_IFACE="eth1" \
    LSDC2_SNIFF_FILTER="udp port $GAME_PORT" \
    LSDC2_PERSIST_FILES="$GAME_SAVENAME.zip" \
    LSDC2_ZIPFROM=$LSDC2_HOME

ENTRYPOINT ["serverwrap"]
CMD ["./start-server.sh"]
