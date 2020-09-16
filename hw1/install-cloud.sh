#!/usr/bin/env bash

set -e
set -x
set -o pipefail

install_deps_dnf() {
	echo "About to install nodejs 10"
	sudo dnf -y module install nodejs:10
	echo "About to install git, make, gettext, g++, python3"
	sudo dnf -y install git make gettext gcc-c++ python3-pip
	echo "About to install yarn"
	curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
	sudo dnf -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps_ubuntu() {
	echo "About to install git, make, gettext, curl, python3"
	sudo apt -y install git make gettext g++ curl python3-pip
	curl -sL https://nodejs.org/dist/latest-v10.x/node-v10.22.1-linux-x64.tar.xz -o node-v10.20.1-linux-x64.tar.xz
	echo "About to install nodejs"
	sudo tar -C /opt --no-same-owner -xf node-v10.22.1-linux-x64.tar.xz
	sudo ln -sf /opt/node-v10.22.1-linux-x64/bin/node /usr/local/bin/node
	sudo ln -sf /opt/node-v10.22.1-linux-x64/bin/npm /usr/local/bin/npm
	echo "About to install yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt -y update
	sudo apt -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps_debian() {
	echo "About to install git, make, gettext, curl, python3"
	sudo apt -y install git make g++ curl python3-pip apt-transport-https gettext
	curl -sL https://nodejs.org/dist/latest-v10.x/node-v10.22.1-linux-x64.tar.xz -o node-v10.20.1-linux-x64.tar.xz
	echo "About to install nodejs"
	sudo tar -C /opt --no-same-owner -xf node-v10.22.1-linux-x64.tar.xz
	sudo ln -sf /opt/node-v10.22.1-linux-x64/bin/node /usr/local/bin/node
	sudo ln -sf /opt/node-v10.22.1-linux-x64/bin/npm /usr/local/bin/npm
	echo "About to install yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt -y update
	sudo apt -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps() {
	if grep -qE "ID(_LIKE)?=.*fedora.*" /etc/os-release ; then
		install_deps_dnf
	elif grep -qE "ID(_LIKE)?=.*ubuntu.*" /etc/os-release ; then
		install_deps_ubuntu
	elif grep -qE "ID(_LIKE)?=.*debian.*" /etc/os-release ; then
		install_deps_debian
	else
		echo "Cannot detect the running distro. Please install nodejs 10.* and yarn using your package manager."
		exit 1
	fi
}

check_deps() {
	for dep in git node npm yarn make g++ msgfmt pip3 ; do
		if ! which $dep >/dev/null 2>&1 ; then
			return 1
		fi
	done
	return 0
}

if ! check_deps ; then
	install_deps
fi

add_path() {
	profile_file=
	if test -f ~/.bash_profile ; then
		profile_file=~/.bash_profile
	else
		profile_file=~/.profile
	fi
	path="$1"
	case "$PATH" in
		*$path*)
			;;
		*)
			echo 'export PATH=$PATH:'$path >> $profile_file
			export PATH=$PATH:$path
			;;
	esac
}

add_path "$HOME/.local/bin"
add_path "$HOME/.yarn/bin"

if grep -qE "ID(_LIKE)?=.*debian.*" /etc/os-release ; then
	PIP=pip
else
	PIP=pip3
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
	${PIP} install --user -e .
	${PIP} install tensorboard
	popd
fi
