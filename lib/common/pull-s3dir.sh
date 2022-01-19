#!/bin/bash

set -Ceu

name=$1

if [ -z "$name" ]; then
    echo "Name not specified" >&2
    exit 1
fi
if [ -e "$HOME/$name" ]; then
    echo "Found: $HOME/$name" >&2
    exit 1
fi

. $HOME/.mydocker3/private/s3-config.sh

archive_dir=$HOME/.mydocker3/archive

s3_last_ls_line=$(aws s3 ls s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz. | LC_ALL=C sort | tail -n1)
if [ -z "$s3_last_ls_line" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi
s3_last_fname=$(echo "$s3_last_ls_line" | awk '{print $4}')
s3_last_num=$(echo "$s3_last_fname" | sed -E -e 's/^.+\.tar\.gz\.([0-9]+)$/\1/')
if [ -z "$s3_last_num" ]; then
    echo "Not found: s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz" >&2
    exit 1
fi

mkdir -p $archive_dir
echo "pull from s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$s3_last_num"
aws s3 cp s3://$s3_archive_bucket/$s3_archive_prefix/$name.tar.gz.$s3_last_num $archive_dir/$name.tar.gz.$s3_last_num

(
    cd $HOME
    tar xzf $archive_dir/$name.tar.gz.$s3_last_num
)

bash $HOME/.mydocker3/public/lib/common/dir-hash.sh $name $archive_dir/$name.tar.gz $s3_last_num

