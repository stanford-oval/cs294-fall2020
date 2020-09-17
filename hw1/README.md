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

## Part 2. Writing Annotations
In this part, we will use Genie to generate a training set of Wikidata questions and their corresponding ThingTalk code.
To do so, we will learn how to write annotations on each property in Wikidata, to teach Genie how to refer to that property in natural language.

We will use the wikidata starter code in Genie. Get into the directory:
```bash
cd genie-toolkit/starter/wikidata
```

Follow the **Configuration** instructions in the [`README.md` file](https://github.com/stanford-oval/genie-toolkit/blob/wip/wikidata-single-turn/starter/wikidata/README.md)
to configure the starter code (skip the Installation part).

Follow **Step 1** and **Step 2** to generate a **small-size** dataset. After you are done, you will obtain both the _manifest_ with the declarations of the queries your skill will support, as well as the dataset of sentences.

Now, follow the instructions in **Step 3** of the README and in the [Thingpedia guide](https://wiki.almond.stanford.edu/thingpedia/guide/natural-language) to edit the manual annotations for each property. Write as many annotations as you can, and keep iterating small size datasets to see the effect of your annotations.

### Questions
1. How many forms can you come up?
2. Are all the generated sentences grammatically correct (ignoring minor things like singular/plural)?
3. Are there sentences that you cannot get Genie to generate? Are they specific to this domain, or are they general forms?

## Part 3. Training and Evaluating a Model
In this part, we will train a neural model that can translate natural language into ThingTalk queries. We will then use the 20 questions you came up with to evaluate the model, and see how well we did.

Follow **Step 2** in the [`README.md` file](https://github.com/stanford-oval/genie-toolkit/blob/wip/wikidata-single-turn/starter/wikidata/README.md) to generate a 
full size dataset, and follow **Step 4** to train the model. **This will take several hours** on the Google Cloud VM, so budget your time in advance.

Now you have a trained model, you can use it to annotate the 20 questions you came up with. 
Use the questions that use properties that exist in Wikidata (the second set of 20 questions).
Copy over the questions from the spreadsheet and put them under `$(exp)/eval/input.txt`, 
with one question each line, and in the first line put "utterance".

Follow **Step 6** to annotate the data and evaluate the model. You can ask the TA for help with annotations, at office hours or in the [class community forum](https://community.almond.stanford.edu/c/cs294sw-aut2020/14).

### Questions
1. Can you obtain at least **50% accuracy** on the questions you wrote? If you do not achieve the accuracy, you can try again with a more varied dataset, with more annotations that more closely match the questions in the dev set.
2. Did you need to drop any sentence? Why?
3. **Extra**: Can you improve the accuracy? How high can you go?

**Note**: You do not need to prepare a _test set_, only a dev set.

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
- a text file with the written answers to the questions in part 2 and part 3
- the final accuracy obtained by your model
