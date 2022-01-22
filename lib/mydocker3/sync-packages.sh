
# entrypoint-user.sh から起動されるスクリプト
# setup-instance.sh から起動されるスクリプト

set -Ceu
cd $(dirname $0)
. ../../env.sh

callfrom="${1:-}"

sudo touch /etc/sudoers.tmp
if ! sudo cat /etc/sudoers | grep '%sudo ALL=NOPASSWD: ALL'; then
  echo "update: /etc/sudoers"
  echo '%sudo ALL=NOPASSWD: ALL' | bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh tee -a /etc/sudoers > /dev/null
fi
if [ ! -e /etc/sudo.conf ] || ! sudo cat /etc/sudo.conf | grep 'Set disable_coredump false'; then
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

bash $MYDOCKER3_PATH/public/packages/apt1.sh
bash $MYDOCKER3_PATH/public/packages/awscli.sh
bash $MYDOCKER3_PATH/public/packages/apt2.sh
bash $MYDOCKER3_PATH/public/packages/python.sh

if [ "$callfrom" = "--from-setup-instance" ] || [ "$callfrom" = "--from-entrypoint-user" ]; then
  exit
fi

bash $MYDOCKER3_PATH/public/packages/tools.sh
bash $MYDOCKER3_PATH/public/packages/nodejs.sh
bash $MYDOCKER3_PATH/public/packages/docker.sh
bash $MYDOCKER3_PATH/public/packages/java.sh
bash $MYDOCKER3_PATH/public/packages/scala.sh
bash $MYDOCKER3_PATH/public/packages/sbt.sh
