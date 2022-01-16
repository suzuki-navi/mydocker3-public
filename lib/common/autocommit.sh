
updatecomment=$1
if [ -z "$updatecomment" ]; then
    updatecomment="autocommit"
fi

git add -A && git status -s
if [ $? -ne 0 ] ; then
    exit 1
elif [ $(git status -s | wc -l) = 0 ]; then
    if git pull --rebase </dev/null; then
        if [ "$(git show -r origin/master | grep \"^commit\")" != "$(git show master | grep \"^commit\")" ]; then
            git push
            if [ $? -ne 0 ] ; then
                exit 1
            fi
        fi
        exit 0
    else
        exit 1
    fi
fi

git commit -m "$updatecomment"
if [ $? -ne 0 ] ; then
    exit 1
fi

git pull </dev/null
if [ $? -ne 0 ] ; then
    exit 1
fi

git push

