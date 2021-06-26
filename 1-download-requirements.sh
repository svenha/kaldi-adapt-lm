#!/bin/bash
# Download Kaldi and KenLM
mkdir -p kaldi
mkdir -p kenlm
if [ -n "$(uname -m | grep aarch64)" ]; then
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kaldi-2021_arm64.tar.gz
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kenlm-20210107_arm64.tar.gz
	tar --strip-components=1 -xzvf kaldi-2021_arm64.tar.gz -C kaldi
	tar -xzvf kenlm-20210107_arm64.tar.gz -C kenlm
elif [ -n "$(uname -m | grep armv7l)" ]; then
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kaldi-2021_armv7.tar.gz
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kenlm-20210107_armv7.tar.gz
	tar --strip-components=1 -xzvf kaldi-2021_armv7.tar.gz -C kaldi
	tar -xzvf kenlm-20210107_armv7.tar.gz -C kenlm
else
	# NOTE: x86 32bit build not supported atm
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kaldi-2021_amd64.tar.gz
	wget https://github.com/fquirin/kaldi-adapt-lm/releases/download/v1.0.0/kenlm-20210107_amd64.tar.gz
	tar --strip-components=1 -xzvf kaldi-2021_amd64.tar.gz -C kaldi
	tar -xzvf kenlm-20210107_amd64.tar.gz -C kenlm
fi
