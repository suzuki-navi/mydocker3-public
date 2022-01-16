
# Dockerfile の RUN で起動されるスクリプト
# entrypoint2.sh から起動されるスクリプト

cd $(dirname $0)
. ./env.sh

if [ ! -e $HOME/nobackup/created-at ]; then
  mkdir $HOME/nobackup
  touch $HOME/nobackup/created-at
fi

if [ ! -e $HOME/bin ]; then
  mkdir $HOME/bin
fi

bash packages/apt1.sh
bash packages/awscli.sh
bash packages/apt2.sh
bash packages/python.sh
