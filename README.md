This docker image provides a Minecraft Server that automatically downloads the latest version at boot time.
Both Java and Bedrock editions are supported.

To simply use it, do the following
```
docker run -d -p 25565:25565 -p 19132:19132/udp -e EULA=true eggpan/minecraft
```
