#!/bin/bash
# run.sh
# A wrapper script for interacting with the docker container

# The directory that the script currently is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# The docker image is versioned by a file locate at "./docker/version"
VSN=`cat $DIR/docker/version`

# Ensure the docker image is up-to-date by checking the version file
function ensure_image_exist {
    if ! docker image inspect memes:$VSN > /dev/null 2>&1; then
        echo "Error: The docker image memes:$VSN not found on your machine"
        echo "run the command \"./run.sh build-image\" to create one"
        exit -1
    fi
}

case "$1" in
    shell)
        # Open a shell (bash) inside the container
        ensure_image_exist
        docker run --rm -it \
            --name memes \
            -p 8080:8080 \
            -v $DIR:/opt/memes \
            memes:$VSN \
            /bin/bash
        ;;
    build-image)
        # Build an up-to-date image
        cd $DIR/docker
        docker build -t memes:$VSN .
        ;;
    start-detached)
        # Run in detached mode (no output)
        ensure_image_exist
        echo "run the command \"./run.sh attach\" to reattach"
        docker run --rm -it \
            --detach \
            --name memes \
            -p 8080:8080 \
            -v $DIR:/opt/memes \
            memes:$VSN \
            /startup
        ;;
    start)
        # Run the default startup script which will install all the
        # dependencies for starting the project
        ensure_image_exist
        docker run --rm -it \
            --name memes \
            -p 8080:8080 \
            -v $DIR:/opt/memes \
            memes:$VSN \
            /startup
        ;;
    attach)
        # Attach to the running container
        echo "Press Ctrl-p Ctrl-q to detach"
        docker attach memes
        ;;
    stop)
        # Stop the running container
        docker stop memes
        ;;
    *)
        echo "Usage: ./run.sh <command>"
        echo "command: start | start-detached | stop | attach | shell | build-image"
        ;;
esac
