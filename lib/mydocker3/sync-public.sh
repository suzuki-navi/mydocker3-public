#!/usr/bin/bash

set -Ceu
cd $(dirname $0)
. ../../env.sh

cd $HOME/.mydocker3/public
git pull origin main
