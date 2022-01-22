
set -Ceu

echo '################################################################################'
echo "# credentials"
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
bash $HOME/.mydocker3/public/lib/mydocker3/sync-credentials.sh

echo '################################################################################'
echo "# private"
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
bash $HOME/.mydocker3/public/lib/mydocker3/sync-private.sh

echo '################################################################################'
echo "# public"
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
bash $HOME/.mydocker3/public/lib/mydocker3/sync-public.sh

#echo '################################################################################'
bash $HOME/.mydocker3/public/lib/mydocker3/sync-s3dirs.sh

echo '################################################################################'
echo "# packages"
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
bash $HOME/.mydocker3/public/lib/mydocker3/sync-packages.sh

echo '################################################################################'
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
echo '################################################################################'
