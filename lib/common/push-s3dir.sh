#!/bin/bash

set -Ceu

name=$1

if [ -z "$name" ]; then
    echo "Name not specified" >&2
    exit 1
fi
if [ ! -d "$HOME/$name" ]; then
    echo "Not found: $HOME/$name" >&2
    exit 1
fi

. $HOME/.mydocker3/private/s3-config.sh

archive_dir=$HOME/.mydocker3/archive

s3_last_ls_line=$(aws s3 ls s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz. | LC_ALL=C sort | tail -n1)
if [ -z "$s3_last_ls_line" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2

    s3_last_num=
    next_last_num=0001

    mkdir -p $archive_dir
    # TODO
else
    s3_last_fname=$(echo "$s3_last_ls_line" | awk '{print $4}')
    s3_last_num=$(echo "$s3_last_fname" | sed -E -e 's/^.+\.tar\.gz\.([0-9]+)$/\1/')
    if [ -z "$s3_last_num" ]; then
        echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
        exit 1
    fi

    next_last_num=$(printf "%04d" $(expr $s3_last_num + 1))
fi

# 現在のディレクトリのハッシュファイルを生成
bash $HOME/.mydocker3/public/lib/common/dir-hash.sh $name $archive_dir/$name.tar.gz $next_last_num

if [ -n "$s3_last_num" ]; then
    # ハッシュファイルに差異がなければ終了
    if cmp -s $archive_dir/$name.tar.gz.$s3_last_num.hash $archive_dir/$name.tar.gz.$next_last_num.hash; then
       echo "No changes"
       exit 0
    fi

    # S3上の最新番号がローカルになければエラー
    if [ ! -e $archive_dir/$name.tar.gz.$s3_last_num ]; then
        echo "Perhaps conflicted" >&2
        exit 1
    fi
fi

(
    cd $HOME
    tar cf - $name | gzip -n -c > $archive_dir/$name.tar.gz.$next_last_num.tmp
)
mv $archive_dir/$name.tar.gz.$next_last_num.tmp $archive_dir/$name.tar.gz.$next_last_num

echo "push to s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num"
aws s3 cp $archive_dir/$name.tar.gz.$next_last_num s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$next_last_num

