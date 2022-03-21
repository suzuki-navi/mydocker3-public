
set -Ceu
. $(dirname $0)/../env.sh

bash $HOME/.mydocker3/public/packages/maven.sh

bash $HOME/.mydocker3/public/packages/java.sh 11
# バージョンは11指定

parquet_tools_version=1.10.1

var_dir=$HOME/.mydocker3/packages
git_tag=apache-parquet-${parquet_tools_version}
target_dir=$var_dir/parquet-tools-${parquet_tools_version}

if [ ! -e $target_dir/target/parquet-tools-${parquet_tools_version}.jar ]; then
    if [ -e $target_dir-tmp ]; then
        rm -rf $target_dir-tmp
    fi

    mkdir -p $target_dir-tmp
    (
        cd $target_dir-tmp
        git clone https://github.com/apache/parquet-mr.git .
        git checkout $git_tag
        cd parquet-tools
        $HOME/.mydocker3/packages/maven/bin/mvn clean package -Plocal
    )

    mkdir -p $target_dir/target
    mv $target_dir-tmp/parquet-tools/target/parquet-tools-${parquet_tools_version}.jar $target_dir/target/parquet-tools.jar
    rm -rf $target_dir-tmp

    mkdir -p $target_dir/bin
    echo "#!/bin/bash" > $target_dir/bin/parquet-tools
    echo 'java --illegal-access=deny -jar $HOME/.mydocker3/packages/parquet-tools/target/parquet-tools.jar "$@"' >> $target_dir/bin/parquet-tools
    chmod +x $target_dir/bin/parquet-tools
fi

if [ -e $var_dir/parquet-tools ]; then
    rm $var_dir/parquet-tools
fi

if [ ! -e $var_dir/parquet-tools ]; then
    ln -s $target_dir $var_dir/parquet-tools
fi

