
# Dockerイメージを作成
# ローカルのソースコードから生成する

set -Ceu

cd $(dirname $0)

rm -rf var/public
mkdir -p var/public
cp -v  --preserve=mode,timestamp ../env.sh            var/public/env.sh
cp -v  --preserve=mode,timestamp ../setup-packages.sh var/public/setup-packages.sh
cp -rv --preserve=mode,timestamp ../packages          var/public/packages
cp -rv --preserve=mode,timestamp ../lib               var/public/lib

docker build -t mydocker3 .
