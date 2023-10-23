#!/bin/bash

# Check if nvidia-smi command exists
if command -v nvidia-smi &> /dev/null; then
    # Check if the output of nvidia-smi -L has at least 1 line
    if [[ $(nvidia-smi -L | wc -l) -ge 1 ]]; then
        echo "CUDA is present."
        # Your Docker command for when CUDA is available
        docker run -it --rm \
            --name melodic_desktop \
            --hostname melodic_desktop \
            --env="DISPLAY" \
            --env="QT_X11_NO_MITSHM=1" \
            --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
            -v `pwd`/../Commands/bin:/home/user/bin \
            -v `pwd`/../ExampleCode:/home/user/ExampleCode \
            -v `pwd`/../Projects/catkin_ws_src:/home/user/Projects/catkin_ws/src \
            -v `pwd`/../Data:/home/user/Data  \
            -env="XAUTHORITY=$XAUTH" \
            --gpus all \
            pxl_melodic_full_desktop:latest \
            bash
    else
        echo "CUDA is not present."
        # Your Docker command for when CUDA is not available
        docker run --privileged -it --rm \
            --name melodic_desktop \
            --hostname melodic_desktop \
            --volume=/tmp/.X11-unix:/tmp/.X11-unix \
            -v `pwd`/../Commands/bin:/home/user/bin \
            -v `pwd`/../ExampleCode:/home/user/ExampleCode \
            -v `pwd`/../Projects/catkin_ws_src:/home/user/Projects/catkin_ws/src \
            -v `pwd`/../Data:/home/user/Data \
            --device=/dev/dri:/dev/dri \
            --env="DISPLAY=$DISPLAY" \
            -e "TERM=xterm-256color" \
            --cap-add SYS_ADMIN --device /dev/fuse \
            pxl_melodic_full_desktop:latest \
            bash
    fi
else
    echo "nvidia-smi command does not exist."
    # Your Docker command for when nvidia-smi command doesn't exist
    docker run --privileged -it --rm \
        --name melodic_desktop \
        --hostname melodic_desktop \
        --volume=/tmp/.X11-unix:/tmp/.X11-unix \
        -v `pwd`/../Commands/bin:/home/user/bin \
        -v `pwd`/../ExampleCode:/home/user/ExampleCode \
        -v `pwd`/../Projects/catkin_ws_src:/home/user/Projects/catkin_ws/src \
    	-v `pwd`/../Data:/home/user/Data \
        --device=/dev/dri:/dev/dri \
        --env="DISPLAY=$DISPLAY" \
        -e "TERM=xterm-256color" \
        --cap-add SYS_ADMIN --device /dev/fuse \
        pxl_melodic_full_desktop:latest \
        bash
fi