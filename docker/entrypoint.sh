#!/usr/bin/bash

# Dockerfile の CMD で参照されるスクリプト

#HOST_UID=${LOCAL_UID:-1000}
#HOST_GID=${LOCAL_GID:-1000}
HOST_UID=${LOCAL_UID:-0}
HOST_GID=${LOCAL_GID:-0}
LOCAL_USER=${LOCAL_USER:-mydocker}
LOCAL_HOSTNAME=${LOCAL_HOSTNAME:-}

if [ -n "$LOCAL_HOSTNAME" ]; then
  echo hostname $LOCAL_HOSTNAME
  hostname $LOCAL_HOSTNAME
fi

# ホスト側の実行ユーザーと同一のUID, GIDを持つユーザーを作成
echo "Starting with UID : $HOST_UID, GID: $HOST_GID"
groupadd -g $HOST_GID -o $LOCAL_USER
useradd  -u $HOST_UID -g $HOST_GID -o -m $LOCAL_USER
usermod -aG sudo $LOCAL_USER
export HOME=/home/$LOCAL_USER

export MYDOCKER3_PATH=${MYDOCKER3_PATH:-$HOME/.mydocker3}
export MYDOCKER3_HOME=${MYDOCKER3_HOME:-$HOME}

su -P $LOCAL_USER -c "bash /opt/mydocker3/public/docker/entrypoint2.sh"

if [ -e $HOME/.zshrc ] && [ -x /usr/bin/zsh ]; then
  echo chsh --shell /usr/bin/zsh $LOCAL_USER
  chsh --shell /usr/bin/zsh $LOCAL_USER
fi

su - $LOCAL_USER
