
set -Ceu
. $(dirname $0)/../env.sh

export PYENV_ROOT=/opt/mydocker3/.pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

if [ ! -e $PYENV_ROOT ]; then
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
fi

version=3.9.6

pyenv install --skip-existing -v $version

if [ $(id -u) -eq 0 ]; then
  exit
fi

bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh chown -R $USER $PYENV_ROOT

pyenv global $version

pip install --upgrade pip

pyenv global $version
