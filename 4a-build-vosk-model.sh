#!/bin/bash
# Collect all files of the adapted model (work folder) and build a Vosk-ASR compatible model
set -e
echo ---------------------------COLLECT-------------------------------
ORG_MODEL="model"
WORK_DIR="work"
if [ -d "./adapted_model" ]; then rm -r "adapted_model"; fi
mkdir -p adapted_model/am
mkdir -p adapted_model/conf
mkdir -p adapted_model/graph/phones
mkdir -p adapted_model/ivector
# copy from original model (this is kind of a default file that should probably be tweaked further)
cp $ORG_MODEL/conf/model.conf adapted_model/conf/model.conf
# collect
cp $WORK_DIR/exp/adapt/final.mdl adapted_model/am/final.mdl
cp $WORK_DIR/conf/mfcc_hires.conf adapted_model/conf/mfcc.conf
cp $WORK_DIR/exp/adapt/graph/HCLG.fst adapted_model/graph/HCLG.fst
cp $WORK_DIR/exp/adapt/graph/num_pdfs adapted_model/graph/num_pdfs
cp $WORK_DIR/exp/adapt/graph/num_pdfs adapted_model/graph/num_pdfs
cp $WORK_DIR/exp/adapt/graph/phones.txt adapted_model/graph/phones.txt
cp $WORK_DIR/exp/adapt/graph/words.txt adapted_model/graph/words.txt
cp $WORK_DIR/exp/adapt/graph/phones/word_boundary.int adapted_model/graph/phones/word_boundary.int
cp $WORK_DIR/exp/extractor/* adapted_model/ivector/
mv adapted_model/ivector/splice_opts adapted_model/ivector/splice.conf
cp $WORK_DIR/conf/online_cmvn.conf adapted_model/ivector/online_cmvn.conf
echo "DONE. Check folder: 'adapted_model'"
