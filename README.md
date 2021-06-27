# kaldi-adapt-lm

Adapt Kaldi-ASR nnet3 chain models (e.g. from Zamia-Speech.org) to a customized language model.

## Installation / Quick-Start

- Make sure you have 'git', 'zip' and 'unzip' available (`sudo apt-get install git zip unzip`).
- Clone the repository: `git clone --single-branch https://github.com/fquirin/kaldi-adapt-lm.git`
- Enter the directory: `cd kaldi-adapt-lm`
- Download Kaldi and KenLM: `bash 1-download-requirements.sh`
- Download a model to adapt: `bash 2-download-model.sh en` (choose 'en' or 'de')
- Test adaptation: `bash 3-adapt.sh en` (choose 'en' or 'de')
- Optional: `bash 4a-build-vosk-model.sh` (repackage model to use with Vosk-ASR)

## Tutorial

This is a more detailed description of the adaptation step (see script [3-adapt.sh](3-adapt.sh)). If you haven't done already please follow the installation steps up to this point.

### Create a custom language model

The whole purpose of adaptation is to optimize the ASR model for your own use-case and increase recognition accuracy of your domain.
To make this happen you first need a list of sentences that will represent the domain.
Simply open a new file and write down your sentences, just make sure everything is lower-case and don't use special characters, question marks, comma etc. (note: different models might actually support upper-case ... in theory).  
  
You can start with one of the files inside 'lm_corpus':
```
mkdir adapt
cp lm_corpus/sentences_en.txt adapt/lm.txt
```

It makes sense to limit the language model to the vocabulary the ASR model supports, so let's extract the vocabulary next:
```
MODEL="$(realpath model)"
cut -f 1 -d ' ' ${MODEL}/data/local/dict/lexicon.txt >vocab.txt
```

Please note: This assumes your model actually has the data available at: `${MODEL}/data/local/dict/`.  
  
With those files in place you can now build the new language model using KenLM:
```
KENLM_DIR="$(realpath kenlm)"
export PATH="$KENLM_DIR:$PATH"
cd adapt
lmplz -S 50% --text lm.txt --limit_vocab_file vocab.txt --arpa lm.arpa --order 4 --prune 0 0 1 2 --discount_fallback
```

Notes:
- You might be able to skip `--discount_fallback` if your model is big enough (and should!).
- `--order 4` generates a 4-gram model. You can experiment with 3-gram or 5-gram as well.
- If your model is very small consider to skip pruning (`--prune 0`) or reduce the thresholds further.
- `-S 50%` reduces memory usage, higher values might work for your setup.
- Check out `lmplz --help` for more info and options to optimize your LM.

### Run model adaptation

After you've created you LM you can start the kaldi model adaptation process:
```
KALDI_DIR="$(realpath kaldi)"
KENLM_DIR="$(realpath kenlm)"
export PATH="$KALDI_DIR:$KENLM_DIR:$PATH"
MODEL="$(realpath model)"
ARPA_LM="$(realpath adapt)/lm.arpa"
MODEL_OUT="sepia-custom"
python3 -m adapt -f -k ${KALDI_DIR} ${MODEL} ${ARPA_LM} ${MODEL_OUT}
```

You should find a tar-file of the resulting model inside the auto-generated `work` folder.  
If you're planning to use the model with [Vosk-ASR](https://alphacephei.com/vosk/) (e.g. via SEPIA STT server) you can use `bash 4a-build-vosk-model.sh` to repackage it. The result can be found inside 'adapted_model'.  
  
When you're done you can use `bash 5-clean-up.sh` to zip the content of 'adapted_model' to 'adapted_model.zip' and delete all working folders.

### Note about memory

If you see strange errors during the adaptation process it might be that you ran out of memory.
I've tested the scripts on a Raspberry Pi 4 2GB using small language models and it worked fine, but requirements might increase exponentially depending on the size of you model.

## To-Do

- Explain how to edit the model dictionary to add completely new words
- Add new words automatically to a dict via G2P models e.g. using [Phonetisaurus](https://github.com/AdolfVonKleist/Phonetisaurus)
- `model.conf` file is kind of random. Understand and improve if necessary.

## Links

- [SEPIA STT Server](https://github.com/SEPIA-Framework/sepia-stt-server)
- [Kaldi ASR](http://kaldi-asr.org)
- [KenLM](https://github.com/kpu/kenlm)
- [Zamia Speech](https://zamia-speech.org)

## Requirements

- Python 3
- Kaldi ASR
- KenLM
- zip and unzip (`sudo apt install zip unzip`)

## License

Apache-2.0 licensed unless otherwise noted in the script’s copyright headers.

# Author(s)

Original by [Guenter Bartsch](https://zamia-speech.org)  
Modified by Florian Quirin for https://github.com/SEPIA-Framework
Pre-built Kaldi and KenLM by [Michael Hansen](https://github.com/synesthesiam)
