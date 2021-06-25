# kaldi-adapt-lm

Adapt Kaldi-ASR nnet3 chain models (e.g. from Zamia-Speech.org) to a different language model.

## Tutorial

To create the language model we would like to adapt our kaldi model to we first
need to create a set of sentences. You can start with one of the files inside 'lm_corpus'.
```
cp lm_corpus/sentences_en.txt lm.txt
```

We also want to limit our language model to the vocabulary the audio model supports,
so let's extract the vocabulary next:
```
MODEL="models/kaldi-generic-en-tdnn_250"
cut -f 1 -d ' ' ${MODEL}/data/local/dict/lexicon.txt >vocab.txt
```

With those files in place we can now train our new language model using KenLM:
```
lmplz -o 4 --prune 0 1 2 3 --limit_vocab_file vocab.txt --interpolate_unigrams 0 <lm.txt >lm.arpa
```

Now we can start the kaldi model adaptation process:
```
KALDI_DIR="kaldi"
MODEL="models/kaldi-generic-en-tdnn_250"
ARPA_LM="adapt/lm.arpa"
MODEL_OUT="sepia-en-tdnn_250"
python3 -m adapt -f -k ${KALDI_DIR} ${MODEL} ${ARPA_LM} ${MODEL_OUT}
```

You should find a tar-file of the resulting model inside the work subdirectory.  
  
If at the end of adaptation process you have a lot of messages like "cp: cannot stat
'exp/adapt/graph/HCLG.fst': No such file or directory", then it's highly likely you ran out of memory
during adaptation process. (For example adapting kaldi-generic-en-tdnn_250 model consumes near 12Gb
of RAM).

## Links

- [SEPIA STT Server](https://github.com/SEPIA-Framework/sepia-stt-server)
- [Kaldi ASR](http://kaldi-asr.org)
- [KenLM](https://github.com/kpu/kenlm)
- [Zamia Speech](https://zamia-speech.org)

## Requirements

- Python 3
- Kaldi ASR
- KenLM

## License

Apache-2.0 licensed unless otherwise noted in the script’s copyright headers.

# Author(s)

Original by [Guenter Bartsch](https://zamia-speech.org)  
Modified by Florian Quirin for https://github.com/SEPIA-Framework
