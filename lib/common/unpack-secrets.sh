#!/usr/bin/bash

# 標準入力を復号して、解凍して、カレントディレクトリまたは指定のディレクトリに出力する。
# PACK_PASSWORD という環境変数があれば、それをパスワードにする。
# なければ、パスワードをプロンプトで聞かれる。

set -Ceu

function usage {
cat >&2 <<EOS
# usage
 $0 <TARGET_DIR> [options]

# options
 -h | --help:
 -d | --hash-dst <HASH_FILE>

EOS
  exit 1
}

function error {
  echo "[error] $1" >&2
  exit 1
}

function info {
  echo "[info] $1"
}

DIR=.
HASH_DST=

args=()
while [ "$#" != 0 ]; do
  case $1 in
    -h | --help      ) usage;;
    -d | --hash-dst  ) shift; HASH_DST=$1;;
    -* | --*         ) error "$1 : Unknown option" ;;
    *                ) args+=("$1");;
  esac
  shift
done

if [ "${#args[@]}" -ge 1 ]; then
  DIR=${args[0]}
fi

####################################################################################################
# 復号と解凍
####################################################################################################

tmp_zip=$(mktemp)

if [ -z "${PACK_PASSWORD:-}" ]; then
  PASS_OPT=""
else
  PASS_OPT="-pass env:PACK_PASSWORD"
fi

(
  set -o pipefail
  mkdir -p $DIR
  cd $DIR
  base64 -d | openssl enc -d -aes256 -pbkdf2 $PASS_OPT >| $tmp_zip
  tar xzf $tmp_zip
)
result=$?

rm $tmp_zip

if [ "$result" != 0 ]; then
  exit $result
fi

####################################################################################################
# ハッシュファイル生成
####################################################################################################

# -d が指定されてなければ終了
if [ -z "$HASH_DST" ]; then
  exit 0
fi

# -d が指定されている場合はハッシュファイルを書き出す

(
  cd $DIR
  find . -type f | LC_ALL=C sort | while read path; do
    echo $path
    sed $path -e 's/^/ /g'
  done | sha256sum | cut -b-64
) >| $HASH_DST

####################################################################################################
