#!/usr/bin/bash

# カレントディレクトリまたは指定のディレクトリの全ファイルを圧縮し、暗号化して、標準出力する。
# PACK_PASSWORD という環境変数があれば、それをパスワードにする。
# なければ、パスワードをプロンプトで聞かれる。

set -Ceu

function usage {
cat >&2 <<EOS
# usage
 $0 <TARGET_DIR> [options]

# options
 -h | --help:
 -s | --hash-src <HASH_FILE>
 -d | --hash-dst <HASH_FILE>
 -w | --width <WIDTH>

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
HASH_SRC=
HASH_DST=
WIDTH=76

args=()
while [ "$#" != 0 ]; do
  case $1 in
    -h | --help      ) usage;;
    -s | --hash-src  ) shift; HASH_SRC=$1;;
    -d | --hash-dst  ) shift; HASH_DST=$1;;
    -w | --width     ) shift; WIDTH=$1;;
    -* | --*         ) error "$1 : Unknown option" ;;
    *                ) args+=("$1");;
  esac
  shift
done

if [ "${#args[@]}" -ge 1 ]; then
  DIR=${args[0]}
fi

####################################################################################################
# ハッシュファイル生成
####################################################################################################

tmp_hash=$(mktemp)

(
  cd $DIR
  find . -type f | LC_ALL=C sort | while read path; do
    echo $path
    sed $path -e 's/^/ /g'
  done | sha256sum | cut -b-64
) >| $tmp_hash

# -s が指定されていてそのハッシュファイルから変化がない場合はなにもせずに終了
if [ -n "$HASH_SRC" ] && [ -e $HASH_SRC ] && cmp -s $HASH_SRC $tmp_hash; then
  rm $tmp_hash
  exit 0
fi

# -d が指定されている場合はハッシュファイルを書き出す
if [ -n "$HASH_DST" ]; then
  cat $tmp_hash >| $HASH_DST
fi
rm $tmp_hash

####################################################################################################
# 圧縮と暗号化
####################################################################################################

tmp_zip=$(mktemp)

if [ -z "${PACK_PASSWORD:-}" ]; then
  PASS_OPT=""
else
  PASS_OPT="-pass env:PACK_PASSWORD"
fi

(
  set -o pipefail
  cd $DIR
  tar czf $tmp_zip .
  cat $tmp_zip | openssl enc -e -aes256 -pbkdf2 $PASS_OPT | base64 -w$WIDTH
)
result=$?

rm $tmp_zip

exit $result

####################################################################################################
