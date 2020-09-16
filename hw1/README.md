# Build a QA Skill for a Wikidata Domain with Genie

In this homework, you will learn to use Genie and build a question-answering skill for a Wikidata domain of your choice. 
**Please sign up for the domain [here](https://docs.google.com/spreadsheets/d/1iibWKklrBbH6JD7vJfaMHyMbsipxHrFw6OlCoORdkhI/edit#gid=0?usp=sharing)**. 
Each domain can have a maximum of 2 students. 
This is a group homework, students signed up for the same domain should work together and only submit one zip file at the end.

**Please start early and budget your time accordingly!** 
This homework requires generating a large dataset and training a large neural network. 
Simply running every command once may take more than 10 hours.

## Setup

First, you need to install Genie toolkit and its dependencies. We prepared a script 
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

## Part 1. Collecting Questions
You have chosen a domain you like, you must have a lot of interesting questions for this domain yourself! 
Please write down 20 questions (per student) you would ask for this domain. Put the in the corresponding tab
of this shared [spreadsheet](https://docs.google.com/spreadsheets/d/1PtCa3jnGEeUE-pnN2rK51T9VtQDMEyKWlvwCkyQrqqA/edit?usp=sharing).

Unfortunately, with high probability, not all questions can be answered by the information 
available in Wikidata. Check the list of properties for your domain in [domains.md](./domains.md). 
(**Do not look at it before finishing the 20 questions.**)
Mark the questions that cannot be answered, and comment on why it can not be answered by Wikidata.

Now you have an idea of what kind of information Wikidata has, come up with another 20 questions (per student) 
that can be answered by Wikidata. Put them in the spreadsheet as well, with a blank row to separate with 
previous questions. These questions will serve as the evaluation set for your QA skill.

## Part 2. Writing Annotations
In this part, we will use Genie to generate a training set of Wikidata questions and their corresponding ThingTalk code.
To do so, we will learn how to write annotations on each property in Wikidata, to teach Genie how to refer to that property in natural language.

We will use the wikidata starter code in Genie. Get into the directory:
```bash
cd genie-toolkit/starter/wikidata
```

Follow the instructions in the [`README.md` file](https://github.com/stanford-oval/genie-toolkit/blob/wip/wikidata-single-turn/starter/wikidata/README.md)
to configure the starter code (skip the Installation part).

Follow **Step 1** and **Step 2** to generate a **small-size** dataset. After you are done, you will obtain both the _manifest_ with the declarations of the queries your skill will support, as well as the dataset of sentences.

Now, follow the instructions in **Step 3** of the README and in the [Thingpedia guide](https://wiki.almond.stanford.edu/thingpedia/guide/natural-language) to edit the manual annotations for each property. Write as many annotations as you can. **In this part, you will be graded on the correctness and comprehensiveness of the annotations**. Keep iterating small size datasets to see the effect of your annotations.

## Part 3. Training and Evaluating a Model
In this part, we will train a neural model that can translate natural language into ThingTalk queries. We will then use the 20 questions you came up with to evaluate the model, and see how well we did.

Follow **Step 2** in the [`README.md` file](https://github.com/stanford-oval/genie-toolkit/blob/wip/wikidata-single-turn/starter/wikidata/README.md) to generate a 
full size dataset, and follow **Step 4** to train the model. **This will take several hours** on the Google Cloud VM, so budget your time in advance.

Now you have a trained model, you can use it to annotate the 20 questions you came up with. 
Copy over the answerable questions from the spreadsheet and put them under `$(exp)/eval/input.txt`, 
with one question each line, and in the first line put "utterance".

Follow **Step 6** to annotate the data and evaluate the model. **You should obtain at least 50% accuracy** on the questions you wrote. You should not drop any question, as all questions use properties that exist in Wikidata. You can ask the TA for help with annotations, at office hours or in the [class community forum](https://community.almond.stanford.edu/c/cs294sw-aut2020/14). If you do not achieve the accuracy, you can try again with a more varied dataset, with more annotations that more closely match the questions in the dev set. **You do not need to submit a _test set_**, only a dev set.

**Extra**: Can you improve the accuracy? How high can you go?

## Submission
Your submission should include a complete dialogue agent for a new domain. 
Package the whole starter code and all generated files (datasets, trained models, etc.) 
into a zip file or tarball, then upload it to [Stanford Box](https://stanford.account.box.com/login). 

Each group should submit a text file on Canvas, and include the following information:
- the domain of the group
- SUID of each group member
- a link to the spreadsheet with the first 20 questions (make sure the link is set to be viewable for anyone in Stanford)
- link to the uploaded file on Stanford box (make sure you choose "People in your company" when creating the shared link)
- a code snippet containing the modified `MANUAL_PROPERTY_CANONICAL_OVERRIDE` in `manual-annotations.js`.
- the final accuracy obtained by your model
