#!/bin/bash

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
OUTPUT_DIR=$THIS_DIR/../tree_images
REPOSITORY=https://github.com/Hikoyu/SARS-CoV-2.git
DATA_DIR=$THIS_DIR/`basename $REPOSITORY .git`
README=$DATA_DIR/README.md

cd $THIS_DIR

if [ ! -e $OUTPUT_DIR ]
then
    mkdir $OUTPUT_DIR
fi

Xvfb :1 -screen 0 1024x768x24 &
xvfb_pid=$!

export DISPLAY=:1

if [ -e $REPOSITORY ]
then
    cd $REPOSITORY
    git pull
    cd $THIS_DIR
else
    git clone $REPOSITORY
fi

find ./ -name "*.nwk" | while read nwk
do
    # ./phylogeny/RAxML-NG/AA/univ/SARS-CoV-2_200314.raxml.support.nwk 
    # -> phylogeny_RAxML-NG_AA_univ_SARS-CoV-2_200314.raxml.support.nwk
    output_file=`echo $nwk | sed 's/\.\///g' | sed 's/\//_/g'`.png

    echo "Creating tree from "$nwk 

    /usr/conda/bin/python create_tree_at_container.py $nwk $OUTPUT_DIR/$output_file $README
done

rm $DATA_DIR -rf

kill $xvfb_pid