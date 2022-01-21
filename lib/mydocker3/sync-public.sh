#!/usr/bin/bash

set -Ceu
cd $(dirname $0)
. ../../env.sh

cd $HOME/.mydocker3/public
sed -i .git/config -e 's!https://github.com/suzuki-navi/mydocker3-public.git!git@github.com:suzuki-navi/mydocker3-public.git!g'
git pull
