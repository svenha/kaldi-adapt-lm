#!/bin/bash
# Download base model to adapt
echo ---------------------------BASE_MODEL_DOWNLOAD-------------------------------
MODEL_LANG="help"
if [ -n "$1" ]; then
	MODEL_LANG="$1"
fi
if [ -d "./model" ]; then rm -r "model"; fi
if [ "$MODEL_LANG" = "en" ]; then
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kaldi-generic-en-tdnn_250.zip
	unzip kaldi-generic-en-tdnn_250.zip -d model
elif [ "$MODEL_LANG" = "de" ]; then
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kaldi-generic-de-tdnn_250.zip
	unzip kaldi-generic-de-tdnn_250.zip -d model
elif [ "$MODEL_LANG" = "de_zamia_org" ]; then
	wget https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-de-tdnn_250-r20190328.tar.xz
	mkdir model && tar --strip-components=1 -xf kaldi-generic-de-tdnn_250-r20190328.tar.xz -C model
elif [ "$MODEL_LANG" = "en_zamia_org" ]; then
	wget https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-en-tdnn_250-r20190609.tar.xz
	mkdir model && tar --strip-components=1 -xf kaldi-generic-en-tdnn_250-r20190609.tar.xz -C model
else
	echo "Unknown language argument. Use one of: 'en', 'de', 'en_zamia_org', 'de_zamia_org'"
fi
