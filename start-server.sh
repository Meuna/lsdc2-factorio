#!/bin/bash
export HOME=$FACTORIO_HOME

shutdown() {
    kill -INT $pid
}

curl -s -L $VERSION_URL -o factorio.tar.xz
tar -xJf factorio.tar.xz --directory=..
rm factorio.tar.xz

if [ ! -f $WORLD_NAME.zip ]; then
    ./bin/x64/factorio --create $WORLD_NAME
fi

jq --arg pw "$PASSWORD" '.game_password = $pw' server-settings.json > tmp.json && mv tmp.json server-settings.json

trap shutdown SIGINT SIGTERM

./bin/x64/factorio --start-server "$WORLD_NAME.zip" --server-settings ./server-settings.json --port "$SERVER_PORT" &
pid=$!
wait $pid
