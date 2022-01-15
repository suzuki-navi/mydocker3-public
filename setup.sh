#!/usr/bin/bash

set -Ceu
. $(dirname $0)/env.sh

if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
  echo "cat > $MYDOCKER3_PATH/credentials.txt"
  exit 1
fi

bash $MYDOCKER3_PATH/public/lib/mydocker3/sync-credentials.sh

if [ -e $MYDOCKER3_PATH/credentials3/clone-private.sh ]; then
  bash $MYDOCKER3_PATH/credentials3/clone-private.sh
fi
