#!/usr/bin/bash

# Dockerfile の CMD で参照されるスクリプト

#HOST_UID=${LOCAL_UID:-1000}
#HOST_GID=${LOCAL_GID:-1000}
HOST_UID=${LOCAL_UID:-0}
HOST_GID=${LOCAL_GID:-0}
LOCAL_USER=${LOCAL_USER:-mydocker}

# ホスト側の実行ユーザーと同一のUID, GIDを持つユーザーを作成
echo "Starting with UID : $HOST_UID, GID: $HOST_GID"
groupadd -g $HOST_GID -o $LOCAL_USER
useradd  -u $HOST_UID -g $HOST_GID -o -m $LOCAL_USER
usermod -aG sudo $LOCAL_USER
export HOME=/home/$LOCAL_USER

su -P $LOCAL_USER -c "bash /opt/mydocker3/public/docker/entrypoint2.sh"
su - $LOCAL_USER
