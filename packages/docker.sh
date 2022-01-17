
set -Ceu
. $(dirname $0)/../env.sh

if [ -e /.dockerenv ]; then
    # in Docker
    if ! which docker; then
        if [ -e /var/run/docker.sock ]; then
            echo sudo apt install -y docker docker.io
            sudo apt install -y docker docker.io
            sudo chmod 666 /var/run/docker.sock
        fi
    fi
else
    echo sudo apt install -y docker docker.io
    sudo apt install -y docker docker.io
    sudo addgroup $USER docker
    echo 'tmuxごといったん終了して再接続が必要'
fi
