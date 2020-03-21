@echo off

del %~dp0\tree_images\*.png

docker pull barikan/ete3_with_qt:3.1.1

REM You should change the local directory path.
docker run -it --name "ete3" --rm ^
    -v /c/workspace/internal/SARS-CoV-2/tree:/tmp/tree ^
    barikan/ete3_with_qt:3.1.1 ^
    /bin/bash /tmp/tree/script/create_tree_at_container.sh 
