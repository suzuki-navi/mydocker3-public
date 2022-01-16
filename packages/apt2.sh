
set -Ceu
. $(dirname $0)/../env.sh

bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y make less tmux peco

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
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh apt install -y gcc g++ zlib1g-dev libffi-dev libssl-dev libsqlite3-dev libbz2-dev groff-base
