# Docker - Display GUI

If you are using docker and would like to display the GUI applications from within the docker, please follow the instructions below.

## Step 1

**Create a container with the following command**
A normal display
```bash
# Start the docker container
docker run \
    -d \
    -ti \
    --net=host \
    -v $(pwd):/home \
    --name u16_opencv \
    --cap-add=SYS_PTRACE \
    --env="DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --privileged \
    -v /usr/lib/nvidia-410:/usr/lib/nvidia-410 \
    -v /usr/lib32/nvidia-410:/usr/lib32/nvidia-410 \
    --device /dev/dri \
    ubuntu:16.04
```
Display with OpenGL
```
# Start the docker container
docker run \
    -d \
    -ti \
    --net=host \
    -v $(pwd):/home \
    --name u16_opencv \
    --cap-add=SYS_PTRACE \
    --env="DISPLAY" \
    -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
    --runtime=nvidia \
    -e XAUTHORITY \
    -e NVIDIA_DRIVER_CAPABILITIES=all \
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

Add a user inside the docker container. Most probably when you start your docker container it is using root and some application cannot start when you are root.

```bash
# Add the user bruce, you may skip the details with `enter`
# adduser bruce --disabled-password --uid=3000
adduser bruce --uid=3000
# Use user bruce
su bruce
```

**Explanation**

Command | Explanation
--- | ---
adduser | Adding a new user inside docker container. Set the user id as 3000 and disable the password.
su bruce | Use user bruce.

If you do not do this, you may recieve this error. `You are trying to start vscode as a super user which is not recommended. If you really want to, you must specify an alternate user data directory using the --user-data-dir argument.`

## Step 5

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
- Displaying with nvidia drivers [link](https://github.com/SoonminHwang/dockers/issues/1)
- Docker example that runs nvidia drivers [link](https://github.com/osrf/servicesim/blob/master/docker/Dockerfile)
- Docker example 2 that runs nvidia dirvers [link](https://github.com/henry2423/docker-ros-x11)
