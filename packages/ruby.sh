
# sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

export RBENV_ROOT=/opt/mydocker3/.rbenv
export PATH=$RBENV_ROOT/shims:$RBENV_ROOT/bin:$PATH

version=3.0.2

callfrom="${1:-}"

if [ ! -e $RBENV_ROOT ]; then
  echo sudo git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
  bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh git clone https://github.com/rbenv/rbenv.git $RBENV_ROOT
  bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build
fi

echo sudo chown -R $USER $RBENV_ROOT
bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh chown -R $USER $RBENV_ROOT

(
  echo "cd $RBENV_ROOT; git pull"
  cd $RBENV_ROOT
  git pull
)

echo rbenv install --skip-existing -v $version
rbenv install --skip-existing -v $version

echo rbenv global $version
rbenv global $version

echo gem install bundler
gem install bundler

echo gem install specific_install
gem install specific_install

echo gem specific_install -l https://github.com/suzuki-navi/suzuki-navi-calendar.git
gem specific_install -l https://github.com/suzuki-navi/suzuki-navi-calendar.git

echo rbenv rehash
rbenv rehash

