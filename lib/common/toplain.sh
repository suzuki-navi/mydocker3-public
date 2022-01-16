
target=$1

if [ -d $target ]; then
  cd $target
  find . -type f | LC_ALL=C sort | while read path; do
    echo $path
    stat --format=%a $path
    sed $path -e 's/^/ /g'
  done
elif [ -e $target ]; then
  stat --format=%a $target
  sed $target -e 's/^/ /g'
fi
