***************************
*Index of Commands and Code
*Assignment 2
***************************

*This index contains everything you need to complete your second assignment


******************************
*1 Loading and Describing Data
******************************

set more off
cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
*Remember-your dataset must be in the destination specified above!
use ESS7IE.dta

*To describe the contents of a variable:
des agea gndr happy

*To summarise a scale variable:
sum agea
*or to view quartiles:
sum agea, d
*or to customise the output and view specific percentiles:
tabstat agea, statistics(min p25 p50 p75 p90 max count mean sd)

*To tabulate a categorical variable:
tab gndr

*To cross-tabulate two variables:
tab rlgblg gndr, col

*To split summary statistics for a scale variable by groups:
bysort gndr: sum agea


************************
*2 Coding Missing Values
************************

*First, inspect the value labels and see what values are coded missing:
label list alcwkdy
*...and then tell stata what to count as missing:
mvdecode alcwkdy, mv(6666 7777 8888 9999=.a)
*...another example using an attitude variable:
label list imbgeco
mvdecode imbgeco, mv(77=.a)
*...and check it has worked by tabulating the variable:
tab imbgeco


***********************************
*3 Recoding and Labelling Variables
***********************************

*To recode a variable by changing the categories:
label list gndr
*...and now to recode male as 0 and female as 1:
recode gndr (1=0) (2=1), gen(gender)
*...now create a label for the new values
label define gender 0"Male" 1"Female"
label values gender gender
label list gender


***************************
*4 Sorting Data Into Groups
***************************

*In this example, we want to group religion into high-medium-low.
*First, inspect the value labels and assign missing codes:
label list rlgdgr
mvdecode rlgdgr, mv(77 88 99=.a)
*As always, inspct the variable before making changes:
tab rlgdgr
*The scale runs from 0-10. We want to produce three groups.
*Let's say group 1(low) will be 3 or less, group 2(med) 6-4,
*and group 3(high) 7-10.
gen relgrp1 = recode(rlgdgr, 3, 6, 10)
tab relgrp1
*...or try this way to generate 3 sequential labels:
gen relgrp2 = irecode(rlgdgr, 3, 6, 10)
tab relgrp2
*...finally, label the new groups
label define relgrp 0"low religiosity" 1"med religiosity" 2"high religiosity"
label values relgrp2 relgrp
tab relgrp2

*To group data into quantiles (quartiles, deciles, quintiles...):
*...using the example of weight:
label list weight
mvdecode weight, mv(777 888 999=.a)
*Group into quartiles (4 rank-ordered groups with same number of observations)
xtile weightq = weight, nquantiles(4)
tab weightq
*...or rroup into deciles (10 rank-ordered groups with same number of observations)
xtile weightd = weight, nquantiles(10)
tab weightd

*To group the variable into groups with the same width:
gen weight4 = recode(weight, 70, 100, 130, 160)
tab weight4

*Group by intervals (bands with same width)
gen weight4 = recode(weight, 70, 100, 130, 160)

*A more complex way is to define a number of groups and range of values:
*...the autocode command uses these parameters (var, k, min, max)
*First, inspect the variable
tabstat weight, statistics(min p25 p50 p75 p90 max count mean sd)
*...and now we generate a set of 10 groups using minimum and maximum values:
gen weight10 = autocode(weight, 10, 39.9, 180)
*...as you can see, Stata automatically sets the group boundaries:
tab weight10
*...the width of the groups is identical for all 10 categories


*********************
*4 Data Visualisation
*********************

*HISTOGRAM

*To produce a histogram with percentage/fraction instead of density:
hist agea, percent
hist agea, fraction
*To vary the number of bins:
hist agea, percent bin(10)
hist agea, percent bin(30)
hist agea, percent bin(60)
*...and to superimpose a normal curve:
hist agea, percent bin(60) normal
*...and to produce a histogram with constant bin widths:
hist agea, percent width(5)

*A useful alternative is the kernel density plot:
label list agea
mvdecode agea, mv(999=.a)
kdensity agea
*You can vary the bandwidth of the smoother with:
kdensity agea, bwidth(2)
*This type of distribution plot is better for overlaying and comparing groups:
label list alcwkdy
mvdecode alcwkdy, mv(6666 7777 8888 9988=.a)
graph twoway || kdensity alcwkdy if gndr==1/*
*/ || kdensity alcwkdy if gndr==2

*BOXPLOT

*Boxplots are very useful for inspecting the shape of a distribution
graph box agea
graph box rlgdgr
*...you can also split them by categories:
graph box agea, over(gndr)
graph box rlgdgr, over(gndr)
*...and to label outlier points:
graph box weight, medtype(line)  mark(1, mlabel(weight))

*SCATTERPLOT

******use international_2009.dta for the following********
use international_2009, clear

*The basic scatterplot command is given by:
graph twoway scatter gini_net expend
*Or it's shorter version:
scatter gini_net expend

*The very helpful scatterplot matrix graphs multiple variables:
graph matrix gini_net expend trade direct

*You can add a linear trend line with:
graph twoway (scatter gini_net expend) (lfit gini_net expend)
*...and label points with:
graph twoway (scatter gini_net expend, mlabel(country)) (lfit gini_net expend)

*GRAPH MODIFICATION

*To modify the x and y axes of a graph:
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50))
scatter gini_net expend, xscale(range(0 100)) yscale(range(0 100))
 *...or to modify the way Stata labels the graph axes:
 scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50))/*
 */ylabel(20(5)50) xlabel(30(2)60)

*Finally, we can alter labels and titles with the following:
 scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50))/*
*/ylabel(20(5)50) xlabel(30(2)60) mlabel(cty) /*
*/ytitle("Gini Inequality") xtitle("Government Expenditure") /*
*/title(Inequality and Government Spending) /*
*/note(Gini Inequality (0-100) and Government Spending (% GDP)) /*
*/subtitle(2009)

*To save graphs, run the 'graph export' command after the graph is produced:
graph twoway (scatter gini_net expend) (lfit gini_net expend)
graph export inequality1.tif

******use ESS7IE.dta for the following********use ESS7IE, clear

*BAR CHARTS

*The easy 'cheat' is to use a histogram with discrete option:
label list prtclaie
mvdecode prtclaie, mv(66 77 88 99=.a)
*We can also 'cheat' by using discrete value histograms for variables with few categories:
hist prtclaie, discrete percent
*...and moodify the labels on the axis
hist prtclaie, discrete percent xlabel(1(1)10)
*And we can add supporting details:
hist prtclaie, discrete percent xlabel(1(1)10) /*
*/addlabels xlabel(1(1)10, valuelabel angle(45)) /*
*/gap(15) title(Irish Party Support 2014)

*Graphs can be split by categories.
*Too many categories will make the graph unreadable however.
*Let's split party support by gender and inspect it more closely:
hist prtclaie, discrete percent xlabel(1(1)10) /*
*/addlabels xlabel(1(1)10, valuelabel angle(45)) /*
*/gap(15) title(Irish Party Support 2014) by(gndr)


**************************************
*4 Multiple Regression and Disgnostics
**************************************

*Remember for OLS regression, we assume the DV/outcome variable is scale.
*Logistic regression and its extensions deal with categorical outcomes.

******start with international_2009******
use international_2009, clear

*First, check whether the DV is correlated with your IVs.
*Check, also, that DVs are not strongly correlated amongst each other:
pwcorr gini_net service trade expend, sig star(.05)
graph matrix gini_net service trade expend

*Second, see if some more elaborate graphs help your inspection:
twoway (scatter gini_net trade) (lfit gini_net trade)
*You can also label the data by location
twoway (scatter gini_net expend, mlabel(cty)) (lfit gini_net expend)

*Third, we run the regression model
reg gini_net expend
*And finish by plotting the residuals against the fitted values
rvfplot, yline(0) mlabel(cty)

*Let's add another variable to the model
reg gini_net expend trade

*REGRESSION DIAGNOSTICS

*Taking the previoous model:
reg gini_net expend trade
*We now explore the key assumptions of OLS modeling.

*HETEROSCEDASTICITY

*To plot the model residuals vs. the fitted values:
rvfplot, yline(0)
*...or to implement the Breusch-Pagan test Ho Constant Variance
reg gini_net expend trade
hettest

*MULTICOLINEARITY

*After the regression command:
reg gini_net expend trade
*Type....
vif
*...to return the table of variance inflation factors

*CATEGORICAL PREDICTORS

******using ESS7IE******

*To alter the base category of a cateogrical predictor:
reg trust i.brncntr ib(#5).health
*Where '#5' is the label number of the category you wish to use as base
