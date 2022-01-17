
# Dockerfile, sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

echo sudo apt install -y curl unzip
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y curl unzip
echo sudo apt install -y git zsh
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y git zsh
