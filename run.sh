#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker run --rm -it -p 8080:8080 -v $DIR:/opt/memes memes /startup
