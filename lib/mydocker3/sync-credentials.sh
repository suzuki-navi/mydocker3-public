#!/usr/bin/bash

set -Ceu
. $(dirname $0)/../../env.sh

function copy() {
  local cptype="$1"
  local src="$2"
  local dst="$3"
  local name="$4"
  bash $MYDOCKER3_PATH/public/lib/common/copy.sh "$cptype" "$src/$name" "$dst/$name"
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

function copy_credentials1_to_credentials23() {
  copy overwrite $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials2 clone-private.sh
  copy overwrite $MYDOCKER3_PATH/credentials1 $MYDOCKER3_PATH/credentials3 clone-private.sh
}

# credentialsディレクトリ
# - credentials1: credentials.txt を外部から設置したときの
# - credentials2: credentials.txt をHOMEに反映したときの
# - credentials3: HOMEからcredentialsに取り込み、credentials.txtを更新したときの

if [ -e $MYDOCKER3_PATH/credentials.txt ]; then
  cat $MYDOCKER3_PATH/credentials.txt | sha256sum | cut -b-64 >| $MYDOCKER3_PATH/credentials.hash.txt.new
  if [ ! -e $MYDOCKER3_PATH/credentials.hash.txt ]; then
    touch $MYDOCKER3_PATH/credentials.hash.txt
  fi
  if ! diff $MYDOCKER3_PATH/credentials.hash.txt $MYDOCKER3_PATH/credentials.hash.txt.new >/dev/null; then
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
copy_credentials1_to_credentials23

if diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials3 >/dev/null; then
  # credentials2 と credentials3 が同じ場合

  if diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1 >/dev/null; then
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

  if diff -r $MYDOCKER3_PATH/credentials2 $MYDOCKER3_PATH/credentials1 >/dev/null; then
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

  elif diff -r $MYDOCKER3_PATH/credentials3 $MYDOCKER3_PATH/credentials1 >/dev/null; then
    # 初回実行時など
    # credentials3 と credentials1 が同じ場合

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
