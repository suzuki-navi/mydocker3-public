
# Dockerfile の RUN で起動されるスクリプト
# entrypoint-user.sh から起動されるスクリプト
# setup-instance.sh から起動されるスクリプト

cd $(dirname $0)
. ./env.sh

sudo touch /etc/sudoers.tmp
if ! sudo cat /etc/sudoers | grep '%sudo ALL=NOPASSWD: ALL'; then
  echo "update: /etc/sudoers"
  echo '%sudo ALL=NOPASSWD: ALL' | bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh tee -a /etc/sudoers > /dev/null
fi
if [ -e /etc/sudo.conf ] && ! sudo cat /etc/sudo.conf | grep 'Set disable_coredump false' || [ ! -e /etc/sudo.conf ]; then
  echo "update: /etc/sudo.conf"
  echo 'Set disable_coredump false' | bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh tee -a /etc/sudo.conf >/dev/null
fi

if [ ! -e $HOME/nobackup/created-at ]; then
  echo "touch ~/nobackup/created-at"
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
bash packages/nodejs.sh

#bash packages/docker.sh
