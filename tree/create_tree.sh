#!/bin/bash

OUTPUT_DIR=/root/tree/output
REPOSITORY=https://github.com/Hikoyu/SARS-CoV-2.git

cd ~/
mkdir $OUTPUT_DIR

Xvfb :1 -screen 0 1024x768x24 &
export DISPLAY=:1

git clone $REPOSITORY

find ./ -name "*.nwk" | while read nwk
do
    # ./phylogeny/RAxML-NG/AA/univ/SARS-CoV-2_200314.raxml.support.nwk 
    # -> phylogeny_RAxML-NG_AA_univ_SARS-CoV-2_200314.raxml.support.nwk
    output_file=`sed 's/\.\///g' | sed 's/\//_/g'`.png
    python create_tree.py $nwk $OUTPUT_DIR/$output_file
done
