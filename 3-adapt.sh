#!/bin/bash
# Adapt model
set -e
echo ---------------------------LM_ADAPT_DE-------------------------------
KALDI_DIR="$(realpath kaldi)"
KENLM_DIR="$(realpath kenlm)"
export PATH="$KALDI_DIR:$KENLM_DIR:$PATH"
MODEL="$(realpath model)"
mkdir -p adapt
cp lm_corpus/sentences_de.txt adapt/lm.txt
cut -f 1 -d ' ' ${MODEL}/data/local/dict/lexicon.txt >adapt/vocab.txt
cd adapt
lmplz -o 4 -S 50% --prune 0 1 2 3 --limit_vocab_file vocab.txt --interpolate_unigrams 0 <lm.txt >lm.arpa
#TODO: remove for larger corpus(??): --discount_fallback
# -S flag sets memory usage
cd ..
ARPA_LM="$(realpath adapt)/lm.arpa"
MODEL_OUT="sepia-de"
python3 -m adapt -f -k ${KALDI_DIR} ${MODEL} ${ARPA_LM} ${MODEL_OUT}
