
# Dockerイメージを作成
# ローカルのソースコードから生成する

set -Ceu

cd $(dirname $0)

rm -rf var/public
mkdir -p var/public
cp -v  --preserve=mode,timestamp ../env.sh            var/public/env.sh
cp -rv --preserve=mode,timestamp ../packages          var/public/packages
cp -rv --preserve=mode,timestamp ../lib               var/public/lib

docker build --build-arg HTTP_PROXY=${HTTP_PROXY:-} --build-arg HTTPS_PROXY=${HTTPS_PROXY:-} --build-arg NO_PROXY=${NO_PROXY:-} -t mydocker3 .
