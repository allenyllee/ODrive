#!/bin/bash

echo "input parameter: $@"

# source directory of this script
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "SOURCE_DIR:" $SOURCE_DIR

chown guest:guest -R /home/guest/.config /home/guest/.cache

su guest


# run init script here
# $SOURCE_DIR/run_odrive.sh
