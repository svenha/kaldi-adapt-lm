#!/bin/bash
# Adapt model
set -e
echo ---------------------------LM_ADAPT_DE-------------------------------
MODEL_LANG="help"
if [ -n "$1" ]; then
	MODEL_LANG="$1"
fi
KALDI_DIR="$(realpath kaldi)"
KENLM_DIR="$(realpath kenlm)"
export PATH="$KALDI_DIR:$KENLM_DIR:$PATH"
MODEL="$(realpath model)"
MODEL_LEXICON="${MODEL}/data/local/dict/lexicon.txt"
if [ -d "./adapt" ]; then rm -r "adapt"; fi
mkdir -p adapt
SENTENCES="lm_corpus/sentences_${MODEL_LANG}.txt"
MY_DICT="lm_dictionary/my_dict_${MODEL_LANG}.txt"
# Copy language model
if [ -f "$SENTENCES" ]; then
	echo "Copying '$SENTENCES' to 'adapt/lm.txt' ..."
	cp "$SENTENCES" adapt/lm.txt
else
	echo "Sentences file not found: ${SENTENCES}. Please check language argument (e.g. 'de' or 'en')."
	exit
fi
# Optionally merge custom dictionary
if [ -f "$MY_DICT" ]; then
	echo "Mergin new words from '$MY_DICT' with original lexicon '$MODEL_LEXICON' ..."
	sort -u --output="adapt/lexicon.txt" -t' ' -k1,1 "$MY_DICT" "$MODEL_LEXICON"
	rm "$MODEL_LEXICON"
	cp "adapt/lexicon.txt" "$MODEL_LEXICON"
fi
cut -f 1 -d ' ' "$MODEL_LEXICON" >adapt/vocab.txt
cd adapt
#the old way - generates empty arap :-/
#lmplz -o 4 -S 50% --prune 0 1 2 3 --limit_vocab_file vocab.txt --interpolate_unigrams 0 <lm.txt >lm.arpa
#the new way:
lmplz -S 50% --text lm.txt --limit_vocab_file vocab.txt --arpa lm.arpa --order 4 --prune 0 0 1 2 --discount_fallback
#TODO: remove whenever possible: --discount_fallback
cd ..
ARPA_LM="$(realpath adapt)/lm.arpa"
MODEL_OUT="new-$MODEL_LANG"
python3 -m adapt -f -k ${KALDI_DIR} ${MODEL} ${ARPA_LM} ${MODEL_OUT}
