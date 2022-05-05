
# Dockerfile, sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

export PYENV_ROOT=/opt/mydocker3/.pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

version=3.9.6

callfrom="${1:-}"

if [ "$callfrom" = "--from-dockerfile" ]; then
  # Dockerfileから起動の場合

  if [ ! -e $PYENV_ROOT ]; then
    echo git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
    git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
  fi

  echo pyenv install --skip-existing -v $version
  pyenv install --skip-existing -v $version

  echo pyenv global $version
  pyenv global $version

  echo pip install --upgrade pip
  pip install --upgrade pip

  exit
fi

if [ ! -e $PYENV_ROOT ]; then
  echo sudo git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
  bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh git clone https://github.com/pyenv/pyenv.git $PYENV_ROOT
fi

echo sudo chown -R $USER $PYENV_ROOT
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh chown -R $USER $PYENV_ROOT

(
  echo "cd $PYENV_ROOT; git pull"
  cd $PYENV_ROOT
  git pull
)

echo pyenv install --skip-existing -v $version
pyenv install --skip-existing -v $version

echo pyenv global $version
pyenv global $version

echo pip install --upgrade pip
pip install --upgrade pip

echo pip install pipenv
pip install pipenv

