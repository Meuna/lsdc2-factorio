#!/bin/bash
export HOME=$LSDC2_HOME

version_url=https://www.factorio.com/get-download/stable/headless/linux64

curl -s -L $version_url -o factorio.tar.xz
tar -xJf factorio.tar.xz
rm factorio.tar.xz

# We create the file if it is missing or empty (failed S3 download,
# which is expected on new game)
if [ ! -s $GAME_SAVENAME.zip ]; then
    ./factorio/bin/x64/factorio --create $GAME_SAVENAME
fi

SERVER_PASS=${SERVER_PASS:-password}

cat << EOF > server-settings.json
{
  "name": "$GAME_SAVENAME",
  "description": "Le serveur des copains",
  "max_players": 0,
  "game_password": "$SERVER_PASS",
  "visibility": {
    "public": false,
    "lan": false
  }
}
EOF

shutdown() {
    kill -INT $pid
}

trap shutdown SIGINT SIGTERM

./factorio/bin/x64/factorio --start-server "$GAME_SAVENAME.zip" --server-settings ./server-settings.json --port "$GAME_PORT" &
pid=$!
wait $pid
