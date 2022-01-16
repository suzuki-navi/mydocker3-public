
set -Ceu
. $(dirname $0)/../env.sh

bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y curl unzip
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y git zsh
