#!/bin/bash
# This script starts the docker container

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
