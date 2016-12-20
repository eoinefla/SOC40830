**************
*Week 2
**************

*This simple exercise introduces you to Stata with round 7 of the European Social Survey
*Begin your session by defining your directory. Download and save the ESS data file from BlackBoard first
*Make a note of the address of the drive you are using.
*Your directory address will differ from mine, but you can see I am working from the 'Documents' folder in my C drive.
*The following commands will set your directory, list its contents, and load the ESS data.

*NOTE: Any non-command (explanatory) text in a Stata do-file is preceded by '*'
*If you want to make a note on a do-file, but no not place * before the text, Stata assumes you are writing a command.

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
use ESS7IE
set more off

*We will focus on a smaller set of variables here.
*first, describe the contents of the dataset.

describe
des

*Note that des does the same as describe - it is common in Stata to find shortened versions of commands such as this.
*This is a large datafile, so perhaps we may want to shorten the detail.
*The command is listed below, but first, let's see how we check the available help options for a command.

help des

*To get the shortened version, use this command

des, s

*Let's focus on a smaller subset of variables (as you can see, the dataset is quite large)

des cgtsday alcwkdy alcwknd height weight agea wkhtotp

*And finally, let's take a closer look at one variable - frequency of smoking

sum cgtsday

*You may notice the mean is very high (does an average of 515 cigarettes look correct?)
*This is because we have not defined the values for missing cases yet, which are codes by the ESS for this varaible as 666
*You can see that something is amiss by graphing the variable

hist cgtsday

*Let's recode the missing cases so that Stata will omit them when we perform an operation on the variable.

replace cgtsday=. if cgtsday==666
sum cgtsday
hist cgtsday

*This looks a little better, but we may also wish to exclude individuals who report smoking 0 per day

replace cgtsday=. if cgtsday==0
sum cgtsday

*Better?
*Note the new mean and number of observations 
*Let's check the proportion of missing cases in the other variables, using the mdesc shortcut.
*findit is a useful command - it allows us to find and install other user-written packages, and access other help resources.

findit mdesc
mdesc cgtsday alcwkdy alcwknd height weight agea hinctnta wkhtotp

*Sometimes commands can become very long. For convenience, Stata has a line-break feature. 
*Take the following command:

xi: regress polintr i.vote agea rlgdgr i.fclcntr gndr i.eisced, vce(robust) beta

*We can break up long command like this using the /* */ line break feature.
*Just remeber to highlight the whole command before running.

xi: regress polintr i.vote agea /*
*/ rlgdgr i.fclcntr gndr i.eisced, vce(robust) beta

*For a tabular variable, we can display the contents of the varaible as follows

tab prtclaie

*And from here, we can introduce a second variable to produce a cross-tabulation (crosstab)

tab prtclaie gndr

*As you can see, counts are not especially helpful, so we can change the output to display column percentages
*In the command below, nofreq suppresses the cell counts, but you can leave this on if you wish (makes the table a little messy however)

tab prtclaie gndr, col nofreq

*What are the percentages telling you? Let's try the tab command again, but this time we will look at percentages of gender within parties

tab prtclaie gndr, row nofreq

*Let's try recoding some variables for easier analysis. Say we want to check whether smoking is more prevalent amongst women than men.
*There are two ways we could do this - either by using the variable above (with missing cases recoded) or by splitting the results.

bysort gndr: sum cgtsday

*We could also tabulate the data by recoding it
*as you try this exercise, think about what it is doing to the level of measurement precision.
*The following commands generate a new variable, recode and label the values by smoker/nonsmoker, then produce a table.

gen cgtsbin=cgtsday
replace cgtsbin=0 if cgtsbin >=666
replace cgtsbin=1 if cgtsbin >=1
label define cgtsbin 0"Non-Smoker" 1"Smoker"
label values cgtsbin cgtsbin
tab cgtsbin gndr, nofreq row


**************
*Week 3
**************

*Remember - place your own directory address in the first command (H: is my drive)

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
use ESS7IE
set more off

*Let's follow the example in the book to recode the political party variable

tab prtclaie

*This useful command lists the associated codes attached to each label category

label list prtclaie

*Identify the 'left' parties from the labels.
*we assume, purely for demonstration that this includes GP, Lab, PBP, SF, and SP.

gen leftist= (prtclaie==3) | (prtclaie==5) |  /*
*/(prtclaie==6) | (prtclaie==7) | (prtclaie==8) /*
*/ if !missing(prtclaie)

label define leftist 0"Non-left" 1"Left"
label var leftist "left/non-left"
label values leftist leftist
label list leftist
tab gndr leftist, row

*Anything wrong with what we just did?
*RWe need to tell Stata what to do with the missing values

gen prtclaie2=prtclaie
replace prtclaie2=. if prtclaie2==66 | prtclaie2==77
label var prtclaie2 "party closest to, missing recoded"

*For the above command:
*Remember - if recoding, it is good practice to leave the original variable intact and to work from a copy

replace leftist = (prtclaie2==3) | (prtclaie2==5) |  /*
*/(prtclaie2==2) | (prtclaie2==7) | (prtclaie2==8) /*
*/ if !missing(prtclaie2)

label values leftist leftist
tab gndr leftist, row

*Exercise
*Repeat the above, but recode the variable to account for right-wing parties
*You are free to make your own assumptions (in the absence of more formal measures!) of what constitutes right-wing....

*Let's try plotting our voting variable against religion. 
*First, inspect the religion variable.
tab rlgdgr
tab rlgdgr, nol
sum rlgdgr
des rlgdgr

*Take care of the missing categories before running any operations
replace rlgdgr=. if rlgdgr==77 | rlgdgr==88
tab rlgdgr

*.....and inspect the distribution
*(by definition, we shouldn't be using a histogram, but we break the rule temporarily for simplicity)
sum rlgdgr, d
graph box rlgdgr
hist rlgdgr

*Let's try using recode to simplify changing the variable.
*We will do this by creating groups of <=2, 3-6, 7-10.
*There are two ways to do this - what is the difference?
gen rel_grp = recode(rlgdgr, 2, 6, 10)
tab rel_grp

gen rel_grp2 = irecode(rlgdgr, 2, 6, 10)
tab rel_grp2

*Same result, but neater labelling. Assign a label to the values
label define rel 0"low religiosity" 1"medium religiosity" 2"high religiosity"
label values rel_grp2 rel
tab rel_grp2

*Now, check the distribution of this variable against our leftist voting variable
tab rel_grp2 leftist, r

*What do you see? Let's try introducing age. 
*We can do this in a number of ways
bysort leftist: sum agea
tab agea
label list agea
replace agea=. if agea==999
gen age_grp = recode(agea, 20, 29, 39, 49, 59, 69, 79, 99)
tab age_grp

*What is the relationship between religion and age?
tab rel_grp2 age_grp, co nofreq

*What is the relationship between leftist voting preference and age?
tab leftist age_grp, co nofreq

*Add in some different options using the help dialog
help tabulate twoway

*NOTE - you may wish to bookmark section 5.3, pp94-105 on recoding string and time variables
*We won't deal with it here yet, but you may need to refer back to it later.

*As a shortcut, we can redefine missing cases more easily with the mvdecode command
mvdecode imbgeco, mv(77=.a)
mvdecode imbgeco, mv(88=.b)
*You can reverse this using mvencode to restore the previous value
mvencode imbgeco, mv(.a=77)
*But for now, let's keep it as it is
mvdecode imbgeco, mv(77=.a)

*Finally, a useful command is the label list command, which returns label codes
label list rel
label list imbgeco
label list prtclaie

