
set -Ceu
. $(dirname $0)/../env.sh

if which aws >/dev/null; then
  exit 0
fi

cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip

bash $MYDOCKER3_PATH/public/lib/common/sudowr.sh ./aws/install

rm -r aws awscliv2.zip
