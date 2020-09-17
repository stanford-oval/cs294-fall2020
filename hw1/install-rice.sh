#!/usr/bin/env bash

set -e
set -x
set -o pipefail

add_path() {
	profile_file=
	if test -f ~/.bash_profile ; then
		profile_file=~/.bash_profile
	else
		profile_file=~/.profile
	fi
	path="$1"
	mkdir -p "$path"
	case "$PATH" in
		*$path*)
			;;
		*)
			echo 'export PATH=$PATH:'$path >> $profile_file
			export PATH=$PATH:$path
			echo "Your PATH setting has been modified. You must log out and log in again to continue."
			exit 0
			;;
	esac
}

add_path "$HOME/.local/bin"
add_path "$HOME/.yarn/bin"

if ! test -f ~/.local/bin/node ; do
	echo "Installing nodejs"
	curl -sL https://nodejs.org/dist/latest-v10.x/node-v10.22.1-linux-x64.tar.xz -o node-v10.22.1-linux-x64.tar.xz
	tar node-v10.22.1-linux-x64.tar.xz
	ln -sf ./node-v10.22.1-linux-x64/bin/node ~/.local/bin/node
	ln -sf ./node-v10.22.1-linux-x64/bin/npm ~/.local/bin/npm
fi

if ! which yarn >/dev/null 2>&1 ; do
	echo "Installing yarn"
	wget https://yarnpkg.com/latest.tar.gz -O yarn-latest.tar.gz
	tar zvxf yarn-latest.tar.gz
	ln -sf ./yarn-v1.22.5/bin/yarn ~/.local/bin/yarn
	yarn config set prefix ~/.yarn
fi

if ! which thingpedia >/dev/null 2>&1 ; do
	echo "Installing thingpedia cli"
	yarn global add thingpedia-cli
fi

if ! test -d genie-toolkit ; then
	git clone https://github.com/stanford-oval/genie-toolkit
	pushd genie-toolkit >/dev/null
	git checkout wip/wikidata-single-turn
	yarn
	yarn link
	popd >/dev/null
fi

if ! test -d genienlp ; then
	git clone https://github.com/stanford-oval/genienlp
	pushd genienlp
	pip install --user -e .
	pip install tensorboard
	popd
fi
