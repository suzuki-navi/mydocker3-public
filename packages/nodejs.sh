
# Dockerfile, sync-packages.sh から呼び出される

set -Ceu
. $(dirname $0)/../env.sh

callfrom="${1:-}"

if [ "$callfrom" = "--from-dockerfile-1" ]; then
  # Dockerfileから起動の場合

  apt install -y nodejs npm

  exit
fi

if [ "$callfrom" = "--from-dockerfile-2" ]; then
  # Dockerfileから起動の場合

  npm install -g n
  n stable
  apt purge -y nodejs npm

  exit
fi

if [ "$callfrom" = "--from-dockerfile-3" ]; then
  # Dockerfileから起動の場合

  if [ -n "${HTTP_PROXY:-}" ]; then
    sudo npm -g config set       proxy $HTTP_PROXY
  fi
  if [ -n "${HTTPS_PROXY:-}" ]; then
    sudo npm -g config set https-proxy $HTTPS_PROXY
  fi

  exit
fi

if [ "$callfrom" = "--from-dockerfile-4" ]; then
  # Dockerfileから起動の場合

  echo sudo npm install -g @vue/cli
  sudo npm install -g @vue/cli

  exit
fi

if [ "$callfrom" = "--from-dockerfile-5" ]; then
  # Dockerfileから起動の場合

  echo sudo npm install -g serverless
  sudo npm install -g serverless
  sudo npm install -g serverless-step-functions
  sudo npm install -g firebase-tools

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
