
set -Ceu

# bash ./copy.sh overwrite           $repo/.zshrc $HOME/.zshrc
# bash ./copy.sh overwrite           $HOME/.zshrc $repo/.zshrc
# bash ./copy.sh overwrite-from-repo $repo/.ssh $HOME/.ssh
# bash ./copy.sh overwrite-to-repo   $HOME/.ssh $repo/.ssh
# bash ./copy.sh history-from-repo   $repo/.zsh_history $HOME/.zsh_history
# bash ./copy.sh history-to-repo     $HOME/.zsh_history $repo/.zsh_history
# bash ./copy.sh known-hosts-from-repo $repo/.ssh/known_hosts $HOME/.ssh/known_hosts
# bash ./copy.sh known-hosts-to-repo   $HOME/.ssh/known_hosts $repo/.ssh/known_hosts

libpath=$(dirname $0)

function diffr() {
  local target1="$1"
  local target2="$2"
  diff <(bash $libpath/toplain.sh $target1) <(bash $libpath/toplain.sh $target2) >/dev/null
}

function copy() {
    local cptype="$1"
    local src="$2"
    local dst="$3"

    if [ "$cptype" = overwrite-from-repo ]; then
        if [ -d "$src" ]; then
            for f in $(ls -a "$src"); do
                if [ $f != . -a $f != .. ]; then
                    copy "$cptype" "$src/$f" "$dst/$f"
                fi
            done
            return 0
        elif [ -f "$src" ]; then
            cptype=overwrite
        else
            return 0
        fi
    fi

    if [ "$cptype" = overwrite-to-repo ]; then
        if [ -d "$dst" ]; then
            for f in $(ls -a "$dst"); do
                if [ $f != . -a $f != .. ]; then
                    copy "$cptype" "$src/$f" "$dst/$f"
                fi
            done
            return 0
        elif [ -f "$dst" ]; then
            cptype=overwrite
        else
            return 0
        fi
    fi

    [ ! -f "$src" ] && return 0
    [ ! -e "$src" ] && return 0
    [ -e "$dst" ] && diffr $src $dst && return 0

    if [ "$cptype" = overwrite ]; then
        copy_overwrite $src $dst
    fi

    if [ "$cptype" = history-from-repo ]; then
        copy_history_from_repo $src $dst
    elif [ "$cptype" = history-to-repo ]; then
        [ ! -e "$dst" ] && return 0
        copy_history_to_repo $src $dst
    elif [ "$cptype" = known-hosts-from-repo ]; then
        copy_known_hosts_from_repo $src $dst
    elif [ "$cptype" = known-hosts-to-repo ]; then
        [ ! -e "$dst" ] && return 0
        copy_known_hosts_to_repo $src $dst
    fi
}

function copy_overwrite() {
    local src="$1"
    local dst="$2"
    echo $src -\> $dst
    mkdir -p $(dirname "$dst")
    cp --preserve=mode,timestamp -f $src $dst
}

function copy_history_from_repo() {
    local src="$1"
    local dst="$2"
    echo $src -\> $dst
    mkdir -p $(dirname "$dst")
    (
        cat $src
        if [ -e $dst ]; then
          diff -u $src $dst | grep -a -e '^+' | grep -a -v -e '^+++' | cut -b2-
        fi
    ) >| $dst.merged
    mv $dst.merged $dst
}

function copy_history_to_repo() {
    local src="$1"
    local dst="$2"
    [ ! -e $src ] && return
    echo $src -\> $dst
    mkdir -p $(dirname "$dst")
    (
      cat $dst
      diff -u $dst $src | grep -a -e '^+' | grep -a -v -e '^+++' | cut -b2-
    ) >| $dst.merged
    mv $dst.merged $dst
}

function copy_known_hosts_from_repo() {
    local src="$1"
    local dst="$2"
    echo $src -\> $dst
    mkdir -p $(dirname "$dst")
    cat $src $dst | perl -e '
        my @arr = ();
        while (my $line = <STDIN>) {
            unless (grep {$_ eq $line} @arr) {
                print $line;
                push(@arr, $line);
            }
        }
    ' >| $dst.merged
    mv $dst.merged $dst
}

function copy_known_hosts_to_repo() {
    local src="$1"
    local dst="$2"
    echo $src -\> $dst
    mkdir -p $(dirname "$dst")
    cat $dst $src | perl -e '
        my @arr = ();
        while (my $line = <STDIN>) {
            unless (grep {$_ eq $line} @arr) {
                print $line;
                push(@arr, $line);
            }
        }
    ' >| $dst.merged
    mv $dst.merged $dst
}

copy "$@"
