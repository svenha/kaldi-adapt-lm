#!/bin/bash
# Adapt model
echo ---------------------------LM_ADAPT_DE-------------------------------
KALDI_DIR="${realpath kaldi}"
KENLM_DIR="${realpath kenlm}"
MODEL="${realpath model}"
mkdir -p adapt
cp lm_corpus/sentences_de.txt adapt/lm.txt
cut -f 1 -d ' ' ${MODEL}/data/local/dict/lexicon.txt >adapt/vocab.txt
cd adapt
${KENLM_DIR}/lmplz -o 4 --prune 0 1 2 3 --limit_vocab_file vocab.txt --discount_fallback --interpolate_unigrams 0 <lm.txt >lm.arpa
#TODO: remove --discount_fallback
cd ..
ARPA_LM="${realpath adapt}/lm.arpa"
MODEL_OUT="sepia-de"
python3 -m adapt -f -k ${KALDI_DIR} ${MODEL} ${ARPA_LM} ${MODEL_OUT}
