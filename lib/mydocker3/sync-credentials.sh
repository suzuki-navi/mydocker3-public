#!/usr/bin/bash

# entrypoint-user.sh から起動されるスクリプト
# setup-instance.sh から起動されるスクリプト

set -Ceu
cd $(dirname $0)
. ../../env.sh

function pull_credentials() {
  if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
    if [ -e $HOME/.credentials.txt ]; then
      cp $HOME/.credentials.txt $MYDOCKER3_PATH/credentials.txt
    fi
  fi
  if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
    if [ -e /opt/mydocker3/work/.credentials.txt ]; then
      cp /opt/mydocker3/work/.credentials.txt $MYDOCKER3_PATH/credentials.txt
    fi
  fi
}

function push_credentials() {
  if [ -e $HOME/.credentials.txt ]; then
    cp $MYDOCKER3_PATH/credentials.txt $HOME/.credentials.txt
  fi
  if [ -e /opt/mydocker3/work/.credentials.txt ]; then
    cp $MYDOCKER3_PATH/credentials.txt /opt/mydocker3/work/.credentials.txt
  fi
}

pull_credentials

if [ ! -e $MYDOCKER3_PATH/credentials.txt ]; then
  echo "Not found: $MYDOCKER3_PATH/credentials.txt"
  exit 1
fi

function copy() {
  local cptype="$1"
  local src="$2"
  local dst="$3"
  local name="$4"
  bash $MYDOCKER3_PATH/public/lib/common/copy.sh "$cptype" "$src/$name" "$dst/$name"
}

function diffr() {
  local target1="$1"
  local target2="$2"
  diff <(bash $MYDOCKER3_PATH/public/lib/common/toplain.sh $target1) <(bash $MYDOCKER3_PATH/public/lib/common/toplain.sh $target2) >/dev/null
}

function copy_home_to_credentials3() {
  copy overwrite-to-repo $MYDOCKER3_HOME $MYDOCKER3_PATH/credentials3 .aws
  copy overwrite-to-repo $MYDOCKER3_HOME $MYDOCKER3_PATH/credentials3 .ssh
  copy overwrite-to-repo $MYDOCKER3_HOME $MYDOCKER3_PATH/credentials3 .pgpass
}

function copy_credentials2_to_home() {
  copy overwrite-from-repo $MYDOCKER3_PATH/credentials2 $MYDOCKER3_HOME .aws
  copy overwrite-from-repo $MYDOCKER3_PATH/credentials2 $MYDOCKER3_HOME .ssh
  copy overwrite-from-repo $MYDOCKER3_PATH/credentials2 $MYDOCKER3_HOME .pgpass
}

#function copy_credentials1_to_credentials23() {
#  copy overwrite $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials2 clone-private.sh
#  copy overwrite $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials3 clone-private.sh
#}

# credentialsディレクトリ
# - credentials1: credentials.txt を外部から設置したときの
# - credentials2: credentials.txt をHOMEに反映したときの
# - credentials3: HOMEからcredentialsに取り込み、credentials.txtを更新したときの

if [ -e $MYDOCKER3_PATH/credentials.txt ]; then
  cat $MYDOCKER3_PATH/credentials.txt | sha256sum | cut -b-64 >| $MYDOCKER3_PATH/credentials.hash.txt.new
  if [ ! -e $MYDOCKER3_PATH/credentials.hash.txt ]; then
    touch $MYDOCKER3_PATH/credentials.hash.txt
  fi
  if ! diffr $MYDOCKER3_PATH/credentials.hash.txt $MYDOCKER3_PATH/credentials.hash.txt.new >/dev/null; then
    # credentials.txt が更新されていた場合

    if ! bash $MYDOCKER3_PATH/public/lib/common/unpack-secrets.sh $MYDOCKER3_PATH/credentials1 < $MYDOCKER3_PATH/credentials.txt; then
      # 解凍失敗
      if [ -e $MYDOCKER3_PATH/credentials1 ]; then
        rmdir --ignore-fail-on-non-empty $MYDOCKER3_PATH/credentials1
      fi
      exit 1
    fi
    mv $MYDOCKER3_PATH/credentials.hash.txt.new $MYDOCKER3_PATH/credentials.hash.txt
  fi
fi

if [ ! -e $MYDOCKER3_PATH/credentials2 ]; then
  mkdir $MYDOCKER3_PATH/credentials2
fi

# HOMEから credentials3 に反映
if [ -e $MYDOCKER3_PATH/credentials1 ]; then
  if [ ! -e $MYDOCKER3_PATH/credentials3 ]; then
    cp -r --preserve=mode,timestamp -f $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials3
  fi
elif [ ! -e $MYDOCKER3_PATH/credentials3 ]; then
  mkdir -p $MYDOCKER3_PATH/credentials3
fi
copy_home_to_credentials3
#copy_credentials1_to_credentials23

if diffr $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials3; then
  # credentials2 と credentials3 が同じ場合

  if diffr $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1; then
    # credentials2 と credentials1 が同じ場合
    
    # HOME でファイルが消えた場合に備えて念のため
    # credentials2 からHOMEに反映
    copy_credentials2_to_home
    copy_home_to_credentials3

  else
    # credentials2 と credentials1 に差異がある場合

    # credentials1 から credentials2 にコピー
    rm -rf $MYDOCKER3_PATH/credentials2
    cp -r --preserve=mode,timestamp -f $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials2

    # credentials2 からHOMEに反映
    copy_credentials2_to_home
    copy_home_to_credentials3

  fi

else
  # credentials2 と credentials3 に差異がある場合

  if diffr $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1; then
    # credentials2 と credentials1 が同じ場合

    # credentials3 から credentials.txt を生成
    bash $MYDOCKER3_PATH/public/lib/common/pack-secrets.sh -w 200 $MYDOCKER3_PATH/credentials3 >| $MYDOCKER3_PATH/credentials.txt.new
    cat $MYDOCKER3_PATH/credentials.txt.new

    # credentials3 から credentials1,2 にコピー
    rm -rf $MYDOCKER3_PATH/credentials1
    cp -r --preserve=mode,timestamp -f $MYDOCKER3_PATH/credentials3 $MYDOCKER3_PATH/credentials1
    rm -rf $MYDOCKER3_PATH/credentials2
    cp -r --preserve=mode,timestamp -f $MYDOCKER3_PATH/credentials3 $MYDOCKER3_PATH/credentials2

    cat $MYDOCKER3_PATH/credentials.txt.new | sha256sum | cut -b-64 >| $MYDOCKER3_PATH/credentials.hash.txt.new
    mv $MYDOCKER3_PATH/credentials.txt.new $MYDOCKER3_PATH/credentials.txt
    mv $MYDOCKER3_PATH/credentials.hash.txt.new $MYDOCKER3_PATH/credentials.hash.txt
    push_credentials

  elif diffr $MYDOCKER3_PATH/credentials3 $MYDOCKER3_PATH/credentials1; then
    # credentials3 と credentials1 が同じ場合
    # 初回実行時など

    # credentials1 から credentials2 にコピー
    rm -rf $MYDOCKER3_PATH/credentials2
    cp -r --preserve=mode,timestamp -f $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials2

    # credentials2 からHOMEに反映
    copy_credentials2_to_home
    copy_home_to_credentials3

  else
    # credentials2 と credentials1 に差異がある場合

    echo "Conflict!"
    echo
    echo diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials3
    diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials3 || true
    echo
    echo diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1
    diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1 || true
    exit 1

  fi

fi
