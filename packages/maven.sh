
set -Ceu
. $(dirname $0)/../env.sh

bash $HOME/.mydocker3/public/packages/java.sh 11

maven_version=3.6.3

while [ $# -gt 0 ]; do
    case $1 in
        *)
            maven_version=$2
            shift
            ;;
    esac
    shift
done

var_dir=$HOME/.mydocker3/packages
tmppath=$var_dir/maven-${maven_version}-tmp
target_dir=$var_dir/maven-${maven_version}

url="https://ftp.jaist.ac.jp/pub/apache/maven/maven-3/3.6.3/binaries/apache-maven-${maven_version}-bin.tar.gz"
fname="apache-maven-${maven_version}-bin.tar.gz"
tardirname="apache-maven-${maven_version}"

if [ -e $target_dir/bin/mvn ]; then
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

if [ ! -e $var_dir/maven ]; then
    ln -s $target_dir $var_dir/maven
fi

