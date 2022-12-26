#!/bin/bash -e

echo "Starting Minecraft..."

if [ ! -d /data/plugins ]; then
  mkdir -p /data/plugins
fi

if [ ! -f /data/plugins/Geyser-Spigot.jar ]; then
  echo "Downloading Geyser..."
  curl -sL 'https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/spigot/target/Geyser-Spigot.jar' \
    -o /data/plugins/Geyser-Spigot.jar
fi

if [ ! -f /data/plugins/floodgate-spigot.jar ]; then
  echo "Downloading floodgate..."
  curl -sL 'https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/spigot/build/libs/floodgate-spigot.jar' \
    -o /data/plugins/floodgate-spigot.jar
fi

if [ -n "$EULA" ]; then
  echo "eula=${EULA}" > /data/eula.txt
fi

screen -d -m -S minecraft java -jar -Xms2G -Xmx2G /usr/local/bin/paper.jar nogui

terminate() {
  JAVA_PID=$(pgrep java)
  echo Terminating Minecraft...
  kill $JAVA_PID
  while [ true ]; do
    pgrep java > /dev/null && :
    if [ $? -eq 1 ]; then
      echo Terminated Minecraft.
      exit 0
    fi
    sleep 1
  done
}
trap terminate TERM

sleep infinity & wait
