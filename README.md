This docker image provides a Minecraft Server that automatically downloads the latest version at boot time.
Both Java and Bedrock editions are supported.

To simply use it, do the following
```
docker run -d -p 25565:25565 -p 19132:19132/udp -e EULA=true --name minecraft eggpan/minecraft
```


Since the screen command is used to start the server, the screen -r command is used to enter the console.
```
docker exec -ti minecraft screen -r minecraft
```
To detach from the console, use ctrl+a ctrl+d keys
