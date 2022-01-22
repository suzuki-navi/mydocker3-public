
# entrypoint-root.sh から起動されるスクリプト

if [ ! -e $HOME/.mydocker3/public ]; then
  mkdir -p $HOME/.mydocker3
  git clone https://github.com/suzuki-navi/mydocker3-public.git $HOME/.mydocker3/public
else
  (
    cd $HOME/.mydocker3
    git pull
  )
fi

bash $HOME/.mydocker3/public/lib/mydocker3/sync-packages.sh --from-entrypoint-user || echo "Failed: $HOME/.mydocker3/public/lib/mydocker3/sync-packages.sh"
bash $HOME/.mydocker3/public/lib/mydocker3/sync-credentials.sh                     || echo "Failed: $HOME/.mydocker3/public/lib/mydocker3/sync-credentials.sh"

if [ -e $HOME/.mydocker3/credentials1/clone-private.sh ] && [ ! -e $HOME/.mydocker3/private ]; then
  bash $HOME/.mydocker3/credentials1/clone-private.sh
  bash $HOME/.mydocker3/public/lib/mydocker3/sync-private.sh   || echo "Failed: $HOME/.mydocker3/public/lib/mydocker3/sync-private.sh"
fi
