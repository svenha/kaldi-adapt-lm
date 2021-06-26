#!/bin/bash
# Download base model to adapt
wget https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-de-tdnn_250-r20190328.tar.xz
#wget https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-en-tdnn_250-r20190609.tar.xz
mkdir model
tar --strip-components=1 -xf kaldi-generic-de-tdnn_250-r20190328.tar.xz -C model
#tar --strip-components=1 -xf kaldi-generic-en-tdnn_250-r20190609.tar.xz -C model
