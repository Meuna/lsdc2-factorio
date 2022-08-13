#!/bin/bash
export HOME=/tmp

shutdown() {
    kill -INT $pid
}

if [ ! -f $WORLD_NAME.zip ]; then
    ./bin/x64/factorio --create $WORLD_NAME
fi


trap shutdown SIGINT SIGTERM

./bin/x64/factorio --start-server "$WORLD_NAME.zip" --server-settings ./server-settings.json --port "$SERVER_PORT" &
pid=$!
wait $pid
