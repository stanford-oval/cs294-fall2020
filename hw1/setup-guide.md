# Setup Guide

We prepared a script 
[`install-cloud.sh`](https://github.com/stanford-oval/cs294-fall2020/blob/master/hw1/install-cloud.sh)
to install everything. The script is optimized for running in a Google Cloud Platform VM instance, but should work on most modern Linux distros.

### Running on Google Cloud Platform
This homework requires access to significant compute resources, 
including GPUs to train a neural network. 
To simplify that, all students will receive a Google Cloud Platform coupon. 
You should have received an email with instructions to redeem your coupon and apply it to your personal GCP account.

You will be responsible for creating and managing (starting, stopping) the VM instances used by this homework. 
**You will be billed while the instances are running** (and you will be responsible for charges beyond the coupon) 
so make sure you turn off any VM instance you are not using.

It is recommended to create a CPU+GPU instance, using an NVidia V100 GPU (~$2/hour)

We recommend using the Oregon (us-west-1) region, 
as it slightly cheaper and includes a larger set of available machine types, 
but any North American region should work.
See detailed instructions and a tutorial for GCP [here](./google-cloud.md).

### Running on FarmShare
The parts of this homework that do not require GPU training can also be run on
[rice.stanford.edu](https://web.stanford.edu/group/farmshare/cgi-bin/wiki/index.php/Main_Page),
the Stanford cluster dedicated to homework.

To set up rice to run this homework, do:
```bash
ssh rice.stanford.edu
module load anaconda3 gcc
git clone https://github.com/stanford-oval/cs294-fall2020
cd cs294-fall2020/hw1
./install-rice.sh
```

The `install-rice.sh` script might ask you to log out and log in again. In that
case, you should log out, log in, and re-run the script until the message "Installation complete"
appears. **You must execute `module load anaconda3 gcc` every time you log in to rice.**

You can check that the installation was correct by executing the comands:
```bash
genie --help
genienlp --help
```
If either one results in a "command not found" error, there was an error in your
setup. In that case, please post a message in the [class community forum](https://community.almond.stanford.edu/c/cs294sw-aut2020/14)
or ask the TA at office hours.

The script will create a clone of `genie-toolkit` in the `cs294-fall2020/hw1`
directory. Inside the `genie-toolkit` directory, you will find the starter code
for this homework in the `starter/wikidata` folder.


### Manual Installation

For faster iteration, you can install the starter code on your local machine and develop locally.
The installation should work on any modern Linux distro, on OS X with Homebrew, and on Windows 10 with WSL.

The homework requires `nodejs` (==10.*), with `yarn` as a package manager. 
See [nodejs](https://nodejs.org/en/download/releases/) and [yarn](https://classic.yarnpkg.com/en/docs/install/) for installation details. 

You will also need [gettext](https://www.gnu.org/software/gettext/), [wget](https://www.gnu.org/software/wget/), git, make, a C/C++ compiler, and Python 3. 
On Ubuntu, install them with:
```bash
sudo apt install gettext wget git make build-essential g++ python3 python3-pip
```
On Fedora, use:
```bash
sudo dnf install gettext wget git make gcc-c++ python3 python3-pip
```
On Mac, use:
```bash
brew install gettext wget
```
Type `git` to install git from the XCode command-line tools. Python should be already installed, but if not you can also install it from Homebrew.

You can check your installation by running `node --version`, `yarn --version`, `gettext --version`, `wget --version`, and `git --version`.

In addition, you will need [the Thingpedia CLI tools](https://github.com/stanford-oval/thingpedia-cli),
which provide an easy way to download data from and upload data to Thingpedia. 
Run the following command to install the tools: 
```bash
yarn global add thingpedia-cli
```

After installation, you should get a command called `thingpedia`.
If encounter `command not found`, make sure the Yarn global bin directory
(usually `~/.yarn/bin`) is in your PATH. You can find the path with the command
`yarn global bin`.
You can change the location by using the following command:
```
yarn config set prefix ~/.yarn
```

If the directory is not in the PATH, add the following to your `~/.bash_profile` (or `~/.profile`, depending on the distro or OS version)
```bash
export PATH=~/.yarn/bin:$PATH
```
After this change, log out and log in again (in OS X, close the terminal and open it again).

Now, you can install Genie toolkit with the following command: 
```bash
git clone https://github.com/stanford-oval/genie-toolkit
cd genie-toolkit
git checkout wip/wikidata-single-turn
yarn
yarn link
cd ..
```

Note the `git checkout` command. You must use the **wip/wikidata-single-turn** branch of Genie for this assignment.
The branch is likely to be updated often as we respond to feedback on the homework. Check the [class community forum](https://community.almond.stanford.edu/c/cs294sw-aut2020/14) for announcements of fixes.

Finally, you will need to install [genienlp](https://github.com/stanford-oval/genienlp), our ML library.
Run the following command to install it:

```bash
git clone https://github.com/stanford-oval/genienlp
cd genienlp
pip3 install --user -e .
pip3 install --user tensorboard
cd ..
```
