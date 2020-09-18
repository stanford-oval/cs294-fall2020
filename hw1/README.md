# Build a QA Skill for a Wikidata Domain with Genie

In this homework, you will learn to use Genie and build a question-answering skill for a Wikidata domain of your choice. 
**Please sign up for the domain [here](https://docs.google.com/spreadsheets/d/1iibWKklrBbH6JD7vJfaMHyMbsipxHrFw6OlCoORdkhI/edit#gid=0?usp=sharing)**. 
Students work in pairs to handle a domain and to submtit one zip file together. The groups should all work on different domains. So, sign up soon to your favorite domain.

We want all students to have hands-on experience in training a large neural network.  (No prior knowledge in machine learning is assumed.)  
Simply running every command once may take more than 10 hours.
**Please start early and budget your time accordingly!**

## Setup

First, follow the [setup guide](./setup-guide.md) to install Genie toolkit and its dependencies. 
We recommend to set up on rice before we send out Google Cloud credit.

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

## Part 2. Evaluating a Pretrained Model
In this part, we will use your sentences to evaluate a pretrained model prepared by the teaching staff.

We will use the wikidata starter code in Genie. Get into the directory:
```bash
cd genie-toolkit/starter/wikidata
```

Follow the **Configuration** instructions in the [`README.md` file](https://github.com/stanford-oval/genie-toolkit/blob/wip/wikidata-single-turn/starter/wikidata/README.md)
to configure the starter code (skip the Installation part).

Follow **Step 1** to generate the _manifest_ of the QA skill, follow **Steps 2 to 3** to download and evaluate the pretrained model on synthesized.

Now you have a trained model, you can use it to annotate the 20 questions you came up with. 
Use the questions that use properties that exist in Wikidata (the second set of 20 questions).
Copy over the questions from the spreadsheet and put them under `$(exp)/eval/input.txt`, 
with one question each line, and in the first line put "utterance".

Follow **Step 4** to annotate the data and evaluate the model. You can ask the TA for help with annotations, at office hours or in the [class community forum](https://community.almond.stanford.edu/c/cs294sw-aut2020/14).

### Questions
1. Did you need to drop any sentence while annotating? Why?
2. What accuracy do you get on the questions you wrote? Does it match the accuracy on the synthesized data?
3. Look at the error analysis file. Can you identify what kind of errors the model is making?

**Note**: You do not need to prepare a _test set_, only a dev set.

### Notes For Farmshare (Rice)
The models cannot be evaluated directly on **rice**, because PyTorch does not run on rice.
Instead, you must upgrade to **wheat**, a larger and more modern compute node. To do so, from inside run, run the following:
```bash
srun --pty --qos=interactive $SHELL -l
```

This command will give an interactive shell inside a wheat compute node, where you
can run the commands normally. All rice and wheat nodes share the home directory
so you do not need to run the installation again.

## Part 3. Writing Annotations
In this part, we will try to improve the accuracy obtained in Part 1. We will use Genie to generate a training set of Wikidata questions and their corresponding ThingTalk code, aiming to make this dataset as similar to the dev set as possible.
To do so, we will learn how to write annotations on each property in Wikidata, to teach Genie how to refer to that property in natural language.

Follow the instructions in **Step 3** of the README and the [Thingpedia guide](https://wiki.almond.stanford.edu/thingpedia/guide/natural-language) to edit the manual annotations for each property.
Then follow **Step 6** to generate a small-size dataset.
Write as many annotations as you can, and keep iterating small size datasets to see the effect of your annotations.
Finally, follow **Step 6** again to generate a full-size dataset.

### Questions
1. How many forms can you come up?
2. Are all the generated sentences grammatically correct (ignoring minor things like singular/plural)?
3. Are there sentences that you cannot get Genie to generate? Are they specific to this domain, or are they general forms?

### Notes For Farmshare (Rice)
Generating the datasets should be possible inside rice directly, as rice has enough
memory and compute power, but to avoid memory limitations, it is recommended to
use srun to submit a job to wheat:

```bash
srun --mem=18G make experiment=$(exp) datadir
```

## Part 4. Training Your Own Model 
In this part, we will train a neural model using the dataset you have generated. 
Follow the instructions in **Step 7** of the README to run the training. 
The training will take several hours to finish. Once done, evaluate the trained model on the eval set you have created. 
(Similar to Part 2, but with a different model ID)

### Questions
1. What accuracy do you get on the questions you wrote this time? 
2. Do the annotations you added to the system help? 

## Submission
Your submission should include all the work your group did on one domain (one submission per group). 
Package the generated `datadir` into a zip file or tarball, 
then upload it to [Stanford Box](https://stanford.account.box.com/login). 

Each group should submit a text file on Canvas, and include the following information:
- the domain of the group
- SUID of each group member
- link to the uploaded file on Stanford box (make sure you choose "People in your company" when creating the shared link)
- a code snippet containing the modified `MANUAL_PROPERTY_CANONICAL_OVERRIDE` in `manual-annotations.js`.
- written answers to the questions in part 2, 3 and 4.
