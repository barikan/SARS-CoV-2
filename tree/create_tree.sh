#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
rm $THIS_DIR/*.png

docker pull barikan/ete3_with_qt:3.1.1
docker run -it --name "ete3" --rm \
    -v ${THIS_DIR}:/tmp/tree \
    barikan/ete3_with_qt:3.1.1 /bin/bash /tmp/tree/script/create_tree.sh 
