#!/usr/bin/bash

# entrypoint2.sh から起動されるスクリプト

cd $(dirname $0)
. ./env.sh

function copy() {
  local cptype="$1"
  local src="$2"
  local dst="$3"
  local name="$4"
  bash $MYDOCKER3_PATH/public/lib/common/copy.sh "$cptype" "$src/$name" "$dst/$name"
}

####################################################################################################
# 設定ファイル
####################################################################################################

copy overwrite         $MYDOCKER3_HOME $MYDOCKER3_PATH/private .zshenv
copy overwrite         $MYDOCKER3_HOME $MYDOCKER3_PATH/private .zshrc
copy overwrite-to-repo $MYDOCKER3_HOME $MYDOCKER3_PATH/private .ssh
copy overwrite         $MYDOCKER3_HOME $MYDOCKER3_PATH/private .gitconfig

if [ -e $MYDOCKER3_HOME/.gitconfig ]; then (
  # autocommit
  cd $MYDOCKER3_PATH/private
  bash $MYDOCKER3_PATH/public/lib/common/autocommit.sh "autocommit config $(hostname)"
); fi

copy overwrite           $MYDOCKER3_PATH/private $MYDOCKER3_HOME .zshenv
copy overwrite           $MYDOCKER3_PATH/private $MYDOCKER3_HOME .zshrc
copy overwrite-from-repo $MYDOCKER3_PATH/private $MYDOCKER3_HOME .ssh
copy overwrite           $MYDOCKER3_PATH/private $MYDOCKER3_HOME .gitconfig

####################################################################################################
# 履歴ファイル
####################################################################################################

copy history-to-repo $MYDOCKER3_HOME $MYDOCKER3_PATH/private .zsh_history

if [ -e $MYDOCKER3_HOME/.gitconfig ]; then (
  # autocommit
  cd $MYDOCKER3_PATH/private
  bash $MYDOCKER3_PATH/public/lib/common/autocommit.sh "autocommit config $(hostname)"
); fi

copy history-from-repo $MYDOCKER3_PATH/private $MYDOCKER3_HOME .zsh_history

####################################################################################################