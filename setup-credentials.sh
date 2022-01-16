#!/usr/bin/bash

# entrypoint2.sh から起動されるスクリプト

set -Ceu
. $(dirname $0)/env.sh

if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
  if [ -e /opt/mydocker3/work/credentials.txt ]; then
    cp /opt/mydocker3/work/credentials.txt $MYDOCKER3_PATH/credentials.txt
  fi
fi

if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
  echo "Not found: $MYDOCKER3_PATH/credentials.txt"
  exit 1
fi

if [ ! -e $MYDOCKER3_PATH/credentials1 ]; then
  bash $MYDOCKER3_PATH/public/lib/mydocker3/sync-credentials.sh
fi

if [ -e $MYDOCKER3_PATH/credentials1/clone-private.sh ] && [ ! -e $MYDOCKER3_PATH/private ]; then
  bash $MYDOCKER3_PATH/credentials1/clone-private.sh
fi
