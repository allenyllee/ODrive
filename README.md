# ODrive - The Open Source Google Drive client

Google Drive GUI for Windows / Mac / Linux https://liberodark.github.io/ODrive/

This is an unoffical docker image that package the ODrive app. 

## Usage

Because this is a GUI app, you should first setup xsock and xauth to connect to the Xwindow every time the system restart (How to setup? see: https://stackoverflow.com/a/47237975/18514920), and you also need to install [NVIDIA/nvidia-docker](https://github.com/NVIDIA/nvidia-docker) before running this script to get rid of libGL error messages.


```shell
CONTAINER_NAME="odrive"
IMAGE="allenyllee/odrive"

XSOCK=/tmp/.X11-unix
XAUTH_DIR=/tmp/.docker.xauth
XAUTH=$XAUTH_DIR/.xauth

mkdir -p $XAUTH_DIR && touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

nvidia-docker run -d \
    --user guest \
    --name $CONTAINER_NAME \
    --env DISPLAY=$DISPLAY \
    --env XAUTHORITY=$XAUTH \
    --volume $XSOCK:$XSOCK \
    --volume $XAUTH_DIR:$XAUTH_DIR \
    --volume /your/odrive/config:/home/guest/.config/odrive \
    --volume /your/google/drive/folder:/ODrive \
    --cap-add SYS_ADMIN \
    --device /dev/fuse \
    --security-opt apparmor:unconfined \
    --restart always \
    $IMAGE
```
