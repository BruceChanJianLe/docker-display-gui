# Docker - Display GUI

If you are using docker and would like to display the GUI applications from within the docker, please follow the instructions below.

## Step 1

**Create a container with the following command**
```bash
# Start the docker container
docker run \
    -d \
    -ti \
    --net=host \
    -v $(pwd)/..:/home \
    --name u16_opencv \
    --cap-add=SYS_PTRACE \
    --env="DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    ubuntu:16.04 
```

**Explanation**
Attribute | Explanation
--- | ---
run | Run docker container.
-d | Detached mode: run the container in the background and print the new container ID.
-ti | Terminal Interactive (Usually use together, also -it).
--net=host | Use the host's network stack inside the container.
-v | Create a bind mount. If you specify, -v /HOST-DIR:/CONTAINER-DIR, Docker bind mounts /HOST-DIR in the host to /CONTAINER-DIR in the Docker container.
--name u15_opencv | Set the name of the container as `u16_opencv`
--cap-add=SYS_PTRACE | Add Linux capabilities. [Learn more](https://docs.docker.com/engine/reference/run/#/runtime-privilege-and-linux-capabilitieso)
--env="DISPLAY" | Set the DISPLAY variable in env to be the same as the machine.
-v /tmp/.X11-unix:/tmp/.X11-unix:rw | Let Docker container find X server. (Very important)
ubuntu:16.04 | Select container `ubuntu` with tag as `16.04`


## Step 2

**Connecting to the Docker Container**
```bash
# Connect to docker container
docker exec -ti u16_opencv bash
```

**Explanation**
Attribute | Explanation
--- | ---
exec | exec is for running a command inside an already running container. Hence it is extremely useful for debugging conatiners.
-t | Allocate a pseudo-tty.
-i | Keep STDIN open even if not attached.
u16_opencv | Container name.
bash | Run bash, or can also use `/bin/bash`.

## Step 3

Once connected and inside of the docker container, you may update it and install nautilus.

```bash
# Run these commands in the docker container
apt-get update
apt-get upgrade
apt-get install nautilus
```

**Explanation**

Installing nautilus is just to test out the GUI status. If you wish you may also install visual studio code.

## Step 4

Now allow docker using local host to connect to X server.

```bash
# Run this command in any local terminal
xhost +local:docker
```

**Explanation**

This let xhost allow local user call docker to display GUI.

## Finally, launch your GUI application

```bash
# Run nautilus and display current directory
nautilus .
```

## Reference
- Understanding host X [link](https://www.youtube.com/watch?v=Jp58Osb1uFo)
- Understanding --cap-add [link](https://docs.docker.com/engine/reference/run/#/runtime-privilege-and-linux-capabilities)
- Difference between exec and exec -ti [link](https://stackoverflow.com/questions/52970443/whats-the-difference-between-docker-exec-and-docker-exec-it)
- Start a GUI-Application as root in a Ubuntu Container [link](https://forums.docker.com/t/start-a-gui-application-as-root-in-a-ubuntu-container/17069)