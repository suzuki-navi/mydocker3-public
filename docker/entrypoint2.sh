
# entrypoint.sh から起動されるスクリプト

if [ ! -e $HOME/.mydocker3/public ]; then
  mkdir -p $HOME/.mydocker3
  git clone https://github.com/suzuki-navi/mydocker3-public.git $HOME/.mydocker3/public
else
  (
    cd $HOME/.mydocker3
    git pull
  )
fi

bash $HOME/.mydocker3/public/sync-packages.sh    || echo "Failed: $HOME/.mydocker3/public/sync-packages.sh"
bash $HOME/.mydocker3/public/sync-credentials.sh || echo "Failed: $HOME/.mydocker3/public/sync-credentials.sh"

if [ -e $MYDOCKER3_PATH/credentials1/clone-private.sh ] && [ ! -e $MYDOCKER3_PATH/private ]; then
  bash $HOME/.mydocker3/credentials1/clone-private.sh
fi
