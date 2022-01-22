
set -Ceu
. $(dirname $0)/../env.sh

bash $HOME/.mydocker3/public/packages/java.sh 11

scala_version=2.13.1

while [ $# -gt 0 ]; do
    case $1 in
        *)
            scala_version=$1
            ;;
    esac
    shift
done

var_dir=$HOME/.mydocker3/packages
tmppath=$var_dir/scala-${scala_version}-tmp
target_dir=$var_dir/scala-${scala_version}

if [ -e $target_dir/bin/scala ]; then
    exit
fi

url="https://downloads.lightbend.com/scala/${scala_version}/scala-${scala_version}.tgz"
fname="scala-${scala_version}.tgz"
tardirname="scala-${scala_version}"

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

if [ ! -e $var_dir/scala ]; then
    ln -s $var_dir/scala-${scala_version} $var_dir/scala
fi

