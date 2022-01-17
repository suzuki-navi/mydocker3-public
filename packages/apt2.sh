
# Dockerfile, sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

echo sudo apt install -y make less tmux
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y make less tmux

echo sudo apt install -y peco
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y peco || true # なぜかEC2インスタンスだと失敗する

echo sudo apt install -y locales-all
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y locales-all
# perlで以下のwarningが出てしまうのを防ぐため
# perl: warning: Setting locale failed.
# perl: warning: Please check that your locale settings:
#         LANGUAGE = (unset),
#         LC_ALL = (unset),
#         LANG = "en_US.UTF-8"
#     are supported and installed on your system.
# perl: warning: Falling back to the standard locale ("C").

# for pyenv, rbenv
echo sudo apt install -y gcc g++ zlib1g-dev libffi-dev libssl-dev libsqlite3-dev libbz2-dev groff-base
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y gcc g++ zlib1g-dev libffi-dev libssl-dev libsqlite3-dev libbz2-dev groff-base
