#!/bin/bash
# Download base model to adapt
wget https://goofy.zamia.org/zamia-speech/asr-models/kaldi-generic-de-tdnn_250-r20190328.tar.xz
mkdir model
tar --strip-components=1 -xf kaldi-generic-de-tdnn_250-r20190328.tar.xz -C model
