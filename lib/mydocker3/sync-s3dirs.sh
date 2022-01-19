
set -Ceu
cd $(dirname $0)
. ../../env.sh

if [ -e $HOME/.mydocker3/archive ]; then (
    cd $HOME/.mydocker3/archive
    ls | perl -nle '/^(.+)\.tar\.gz\.[0-9]+$/ and print $1'
) fi | LC_ALL=C sort | LC_ALL=C uniq | while read name; do
    if [ -e $HOME/$name ]; then
        echo '################################################################################'
        echo "# $name"
        echo "# $(date '+%Y-%m-%d %H:%M:%S')"
        bash $HOME/.mydocker3/public/bin/push-s3dir $name
    fi
done

echo '################################################################################'
echo "# $(date '+%Y-%m-%d %H:%M:%S')"
echo '################################################################################'

