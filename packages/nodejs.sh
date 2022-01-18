
# Dockerfile, sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

if [ $(id -u) -eq 0 ]; then
  # Dockerfileから起動の場合

  apt install -y nodejs npm
  npm install -g n
  n stable
  apt purge -y nodejs npm

  exit
fi

if ! type node >/dev/null 2>&1; then
  sudo apt install -y nodejs npm
  sudo npm install -g n
  sudo n stable
  sudo apt purge -y nodejs npm
fi

if [ -n "${HTTP_PROXY:-}" ]; then
    sudo npm -g config set       proxy $HTTP_PROXY
fi
if [ -n "${HTTPS_PROXY:-}" ]; then
    sudo npm -g config set https-proxy $HTTPS_PROXY
fi

if ! type vue >/dev/null 2>&1; then
    echo sudo npm install -g @vue/cli
    sudo npm install -g @vue/cli || true
    # なぜかエラー終了する
fi

if ! type serverless >/dev/null 2>&1; then
    echo sudo npm install -g serverless
    sudo npm install -g serverless || true
    sudo npm install -g serverless-step-functions || true
    sudo npm install -g firebase-tools || true
    # なぜかエラー終了する
fi
