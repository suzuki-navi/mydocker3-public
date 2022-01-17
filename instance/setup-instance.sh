#!/usr/bin/bash

# EC2インスタンスまたはGCPのGCEインスタンスを直接セットアップしたい場合にこのスクリプトを実行する

if [ ! -e $HOME/.credentials.txt ]; then
  echo "Not Found: ~/.credentials.txt" >&2
  exit 1
fi

sudo apt update
sudo apt upgrade -y

if [ ! -e $HOME/.mydocker3/public ]; then
  mkdir -p $HOME/.mydocker3
  git clone https://github.com/suzuki-navi/mydocker3-public.git $HOME/.mydocker3/public
else
  (
    cd $HOME/.mydocker3
    git pull
  )
fi

export MYDOCKER3_PATH=${MYDOCKER3_PATH:-$HOME/.mydocker3}
export MYDOCKER3_HOME=${MYDOCKER3_HOME:-$HOME}

bash $HOME/.mydocker3/public/sync-packages.sh    || echo "Failed: $HOME/.mydocker3/public/sync-packages.sh"
bash $HOME/.mydocker3/public/sync-credentials.sh || echo "Failed: $HOME/.mydocker3/public/sync-credentials.sh"

if [ -e $HOME/.mydocker3/credentials1/clone-private.sh ] && [ ! -e $HOME/.mydocker3/private ]; then
  bash $HOME/.mydocker3/credentials1/clone-private.sh
  bash $HOME/.mydocker3/public/sync-private.sh   || echo "Failed: $HOME/.mydocker3/public/sync-private.sh"
fi

if [ -e $HOME/.zshrc ] && [ -x /usr/bin/zsh ]; then
  echo sudo chsh --shell /usr/bin/zsh $USER
  sudo chsh --shell /usr/bin/zsh $USER
fi

