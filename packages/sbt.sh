
set -Ceu

bash $HOME/.mydocker3/public/packages/java.sh

sbt_version=1.5.1

var_dir=$HOME/.mydocker3/packages
tmppath=$var_dir/sbt-${sbt_version}-tmp
target_dir=$var_dir/sbt-${sbt_version}

url="https://github.com/sbt/sbt/releases/download/v1.5.1/sbt-$sbt_version.tgz"
fname="sbt-$sbt_version.tgz"
tardirname="sbt"

if [ -e $target_dir/bin/sbt ]; then
    exit
fi

if [ -e $tmppath ]; then
    rm -rf $tmppath
fi
mkdir -p $tmppath

echo "downloading: $url"
curl -f -L $url > $tmppath/$fname.tmp
mv $tmppath/$fname.tmp $tmppath/$fname

tar xzf $tmppath/$fname -C $tmppath

if [ -e $target_dir ]; then
    rm -rf $target_dir
fi
mkdir -p $(dirname $target_dir)
mv $tmppath/$tardirname $target_dir
rm -rf $tmppath

if [ ! -e $var_dir/sbt ]; then
    ln -s $target_dir $var_dir/sbt
fi


