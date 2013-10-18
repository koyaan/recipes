!#/bin/bash
for D in $(find . -mindepth 1 -maxdepth 1 -type d) ; do
        cd $D
        git status
        cd ..
    echo $D ;
done
