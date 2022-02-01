
set -Ceu

cd $HOME

sudo apt install -y gcc g++ zip unzip rsync tree iputils-ping pv

sudo apt install -y dnsutils
# https://packages.ubuntu.com/bionic/amd64/dnsutils/filelist

sudo apt install -y whois

sudo apt install -y jq nkf
#sudo apt install -y jq || sudo snap install jq
#sudo apt install -y nkf || sudo snap install nkf

sudo apt install -y postgresql-client-12

#sudo apt install -y sudo moreutils vim ncat tcpdump

sudo apt install -y bsdmainutils
# https://qiita.com/suzuki-navi/items/d9228fc776a571ef16c9
# for column, hexdump

pip install git+https://github.com/suzuki-navi/aws-glue-job-history

pip install git-remote-codecommit yq awscli awslogs
# sudoを付けるとなぜかproxy環境で以下が必要になってしまう
# --trusted-host files.pythonhosted.org

