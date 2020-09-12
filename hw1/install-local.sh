#!/usr/bin/env bash

set -e
set -x
set -o pipefail

install_deps_dnf() {
	echo "About to install nodejs 10"
	sudo dnf -y module install nodejs:10
	echo "About to install make, g++"
	sudo dnf -y install make gcc-c++
	echo "About to install yarn"
	curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo
	sudo dnf -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps_ubuntu() {
	echo "About to install make, curl"
	sudo apt -y install make g++ curl
	curl -sL https://nodejs.org/dist/latest-v10.x/node-v10.20.1-linux-x64.tar.xz -o node-v10.20.1-linux-x64.tar.xz
	echo "About to install nodejs"
	sudo tar -C /opt --no-same-owner -xf node-v10.20.1-linux-x64.tar.xz
	sudo ln -sf /opt/node-v10.20.1-linux-x64/bin/node /usr/local/bin/node
	sudo ln -sf /opt/node-v10.20.1-linux-x64/bin/npm /usr/local/bin/npm
	echo "About to install yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt -y update
	sudo apt -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps_debian() {
	echo "About to install make, curl"
	sudo apt -y install make g++ curl apt-transport-https gettext
	curl -sL https://nodejs.org/dist/latest-v10.x/node-v10.20.1-linux-x64.tar.xz -o node-v10.20.1-linux-x64.tar.xz
	echo "About to install nodejs"
	sudo tar -C /opt --no-same-owner -xf node-v10.20.1-linux-x64.tar.xz
	sudo ln -sf /opt/node-v10.20.1-linux-x64/bin/node /usr/local/bin/node
	sudo ln -sf /opt/node-v10.20.1-linux-x64/bin/npm /usr/local/bin/npm
	echo "About to install yarn"
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt -y update
	sudo apt -y install yarn
	echo "About to install thingpedia cli"
	yarn global add thingpedia-cli
}

install_deps_mac() {
    echo "About to install nodejs 10"
	sudo brew install node@10
	echo "About to gettext"
	sudo brew install gettext
	echo "About to install yarn"
	sudo brew install yarn
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
    elif [[ "$OSTYPE" == "darwin"* ]] ; then
        install_deps_mac
	else
		echo "Cannot detect the running distro. Please install nodejs 10.* and yarn using your package manager."
		exit 1
	fi
}

check_deps() {
	for dep in node npm yarn make g++ pip3 ; do
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


if ! test -d thingtalk-units ; then
	git clone https://github.com/stanford-oval/thingtalk-units
	pushd thingtalk-units >/dev/null
	git checkout wip/area
	yarn
	yarn link
	popd >/dev/null
fi

if ! test -d thingtalk ; then
	git clone https://github.com/stanford-oval/thingtalk
	pushd thingtalk >/dev/null
	yarn link thingtalk-units
	yarn
	yarn link
	popd >/dev/null
fi

if ! test -d genie-toolkit ; then
	git clone https://github.com/stanford-oval/genie-toolkit
	pushd genie-toolkit >/dev/null
	git checkout wip/wikidata-single-turn
	yarn link thingtalk-units
	yarn link thingtalk
	yarn
	yarn link
	popd >/dev/null
fi
