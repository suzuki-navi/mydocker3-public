
# Dockerfile の RUN で起動されるスクリプト
# entrypoint2.sh から起動されるスクリプト

cd $(dirname $0)
. ./env.sh

bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y sudo curl unzip
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y zsh
#curl vim openssh-client ncat openssh-server

bash packages/awscli.sh
