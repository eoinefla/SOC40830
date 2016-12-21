****************************************************************
*WEEK 5, DESCRIBING AND VISUALIZING DATA, SESSION 2 (CONCLUSION)
****************************************************************

*NOTE: Any non-command (explanatory) text in a Stata do-file is preceded by '*'
*If you want to make a note on a do-file, but no not place * before the text, Stata assumes you are writing a command.
*We can break up long command like this using the /* */ line break feature.

*************************************************************
*Bar charts (including some cheats using discrete histograms)
*************************************************************

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
clear
use ESS7IE.dta
set more off

*First, lets set up missing codes for a number of variables
label list prtclaie
label list lrscale
label list alcbnge
mvdecode prtclaie, mv(66 77 88 99=.a)
mvdecode lrscale, mv(77 88 99=.a)
mvdecode alcbnge, mv(6 7 8 9=.a)

*Examine the tables for any early signs of patterns
tab prtclaie gndr, col
tab lrscale gndr, col
tab alcbnge gndr, col

*With scale variables, we can introduce another variable by splitting the plot over a category
graph box lrscale, over(gndr)

*We can also 'cheat' by using discrete value histograms for variables with few categories:
hist prtclaie, discrete percent
*The same axis options also work across graph types:
hist prtclaie, discrete percent xlabel(1(1)10)
*And we can add supporting details:
hist prtclaie, discrete percent xlabel(1(1)10) addlabels xlabel(1(1)10, valuelabel angle(45)) /*
*/gap(15) title(Irish Party Support 2014)

*Graphs can be split by categories, but you should balance this against visual needs
*Let's split party support by gender and inspect it more closely:
hist prtclaie, discrete percent xlabel(1(1)10) addlabels xlabel(1(1)10, valuelabel angle(45)) /*
*/gap(15) title(Irish Party Support 2014) by(gndr)


*Bar charts are slightly different
*They are used to display summary statistics across categories
*If you try to use it with the original variable, this happens:
graph bar prtclaie

*We first need to split it into categories using an extension to the tab command
*Take a look at the variables list after running this to see what happens
tab prtclaie, gen(prtbar)
*Now we can graph summary statistics across the categories of prtclaie using the new split variable:
graph bar prtbar*

*Let's try it with another variable, and gender:
tab gndr, gen(gndrbar)
graph bar lrscale, by(gndr)

*This isn't especially remarkable as the difference is trivial
*Let's try it with religion (note: you may have this variable in memory already, if so, step one will return an error, but just ignore this)
gen rel_grp2 = irecode(rlgdgr, 2, 6, 10)
*...and you can add a third variable as before
graph bar lrscale, over(rel_grp2) by(gndr)

*The same information can be represented on a dot chart, which is very simple and effective:
graph dot lrscale, over(rel_grp2)

*Some scale variables for you to experiment with
label list height
mvdecode height, mv(777 888 999=.a)
hist height, bin(50) percent

label list weight
mvdecode weight, mv(777 888 999=.a)
hist weight, bin(50) percent

label list alcwkdy
mvdecode alcwkdy, mv(6666 7777 8888 9999=.a)
tabstat alcwkdy, s(mean min max)
hist alcwkdy, bin(50) percent


**********************
*USEFUL EXTRAS
**********************

*************
*Grouping Data
*************
label list weight
mvdecode weight, mv(777 888 999=.a)
*Group into quantiles (groups with same number of observations)
xtile weightq = weight, nquantiles(4)
tab weightq
xtile weightd = weight, nquantiles(10)
*Group into intervals (bands with same width)
gen weight4 = recode(weight, 70, 100, 130, 160)
bysort gndr: tab weight4
*autocode uses these parameters (var, k, min, max)
tabstat weight, statistics(min p25 p50 p75 p90 max count mean sd)
gen weight10 = autocode(weight, 10, 38, 180)
tab weight10

***********************
*Comparing Distributions
***********************
*You can summarise the mean of a variable across two categories using the followin extensions
*In the following, var1 and var2 are categorical, var3 is scale
tab rel_grp2 gndr, summarize(agea) nostandard nofreq

*You can also sort summary statistics by group using tabstat
tabstat agea, statistics(count min q max mean sd) by(rel_grp2)

*Summary statstics by group can also be displayed using the (slightly more complicated) table command
*You should type 'help table' to view the options for working with this

*********************************************
*Kernel graphs as an alternative to histograms
*********************************************

*Kernel density estimators overcome the problem of choosing arbitrary bins and widths
*The 'kdensity' commands apply variants of the equation on p192 to generate a sliding histogram
*Remember the rules about using these typers of graphs for categorical or ordinal variables
*lrscale is strictly ordinal, but we can 'cheat' in this case - let's try a few different variables
label list lrscale
mvdecode lrscale, mv(77 88 99=.a)
kdensity lrscale

*Kernel density estimators also have bandwidth parameters which you can vary to alter the resolutioin of the graph
label list agea
mvdecode agea, mv(999=.a)
kdensity agea, bwidth(20)
kdensity agea, bwidth(30)
kdensity agea, bwidth(2)

*We can also more easily compare distributions for groups using overlaid kernel plots
label list gndr
mvdecode gndr, mv(9=.a)
graph twoway || kdensity lrscale if gndr==1, bwidth(.5) || kdensity lrscale if gndr==2, bwidth(.5)
ttest lrscale, by(gndr)


************************
*Visualization Exercises
************************

******1******
*Repeat the bar chart for left-right scale (lrscale) by alcohol consumption (alcwkdy)
*Generate two separate bar charts for each gender (gndr)
*Use either the discrete histogram or bar chart method
graph bar lrscale, over(alcbnge) by(gndr)
hist lrscale, discrete xlabel(1(1)10) gap(10) by(gndr) ylabel(0(.1).5) xlabel(0(1)10, valuelabel)

******2******
*Use the histogram method to produce a plot of support for redistribution (gincdif)
*Do so by using the following steps:
*1 Check missing values and recode
*2 Plot the chart for the whole sample
*3 Split the plot across three religiosity groups (rel_grp2)
label list gincdif
mvdecode gincdif, mv(7 8 9=.a)
hist gincdif, discrete
hist gincdif, discrete by(rel_grp2)
hist gincdif, discrete percent addlabel xlabel(1(1)5) by(rel_grp2) note(1=Agree Strongly 5=Disagree Strongly)

******3******
*Produce a dot chart for age (agea) over binge drinking (alcbnge)
*Add a suitable title and notes on the measures to the graph
graph dot agea, over(alcbnge) ytitle(Mean Age) /*
*/title(Mean Age by Frequency of Binge Drinking) note(Measured by self-reported consumption of 4+ units in a single sitting)

******4******
*Switch your data to the Irish Time Series dataset (ireland_time_series.dta)
*Plot the share of taxes in capital, social, and indirect
*Plot the chart as a connected line
*Limit the range of the plot to 1985 onward
use ireland_time_series.dta, clear
tsset year, yearly
twoway connected capital social indirect year if year >=1985
graph export tax.tif
graph save tax
graph use tax

******5******
*Switch your data to the International dataset (international_2009.dta)
*Plot the relationship between female labour force participation (femlp) and market income inequality (gini_market)
*Add a linear fit line to the data
*Repeat the plot using net income inequality (gini_net)
*What do you notice?
use international_2009.dta
twoway (scatter femlp gini_market) (lfit femlp gini_market)
twoway (scatter femlp gini_net) (lfit femlp gini_net)
*Here is the 'honest' version - is this helpful?
scatter gini_net femlp, xscale(range(0 100)) yscale(range(0 100))

*************
*Pie charts
*************

*There is no lesson here. Do not use pie charts. 
*If you really must see one, here it is:
graph pie lrscale, over(rel_grp2)


********************
*Inference exercises
********************

******1******

*DO RELIGIOUS PEOPLE CONSUME MORE ALCOHOL THAN NON-RELIGIOUS?

*Recode the religion variable (rlgdgr) into two groups of 5 and lower, and 6 and higher
*Is there a statistically significant difference in alcohol consumption between low and high religiosity group?
*Produce a kernel density plot of mean alcohol consumption for both groups

*First divide the religion variable and take care of missing case codes
label list rlgdgr
mvdecode rlgdgr, mv(77 88 99=.a)
gen rel_grp = irecode(rlgdgr, 5)
label define rel 0"low religioity" 1"high religiosity"
label values rel_grp rel
tab rel_grp
*Then examine missing codes on alcohol consumption also
label list alcwkdy
mvdecode alcwkdy, mv(6666 7777 8888 9999=.a)

*Try inspecting the data
graph box alcwkdy, over(rel_grp)
mean alcwkdy, over(rel_grp)

*Run the t-test and interpret the output
ttest alcwkdy, by(rel_grp)

*Finally, do a twoway plot of the distributon for each group
twoway kdensity alcwkdy if rel_grp==0 || kdensity alcwkdy if rel_grp==1

*You could clean it up by plotting reference lines
twoway kdensity alcwkdy if rel_grp3==0, xline(68.19)/*
*/ || kdensity alcwkdy if rel_grp3==1, xline(61.98, lpattern(dot))

******2******

*ARE THIRD-LEVEL EDUCATED PEOPLE MORE LEFT-WING?

*Recode the education variable (edlvdie) into third level and above, and below third level
*Hint: the cutoff for third-level education in Ireland is category 7, Leaving Certificate Applied...
*Test the hypothesis that third-level educated individuals are more likely to hold left-wing political views (lrscale)

*First recode the education variable by identifying the cutoff for post leaving cert education
label list edlvdie
mvdecode edlvdie, mv(5555 7777 8888 9999=.a)
gen edgrp=irecode(edlvdie, 7)
tab edlvdie, nol
tab edgrp
label define edgrp 0"leaving cert and below" 1"third level"
label values edgrp edgrp
*Examine the lrscale variable
label list lrscale
mvdecode lrscale, mv(77 88 99=.a)

*Now compare the groups
graph box lrscale, over(edgrp)
mean lrscale, over(edgrp)


******3******

*IS SUPPORT FOR INCOME REDISTRIBUTION GREATER AMONGST THOSE WITH A HISTORY OF TRADE MEMBERSHIP?

*Using both mbtru and gincdif, run a t-test of support for redistribution amongst those with a history of union membership (past or current) and those with none.
label list mbtru
mvdecode mbtru, mv(7 8 9=.a)
label list gincdif
mvdecode gincdif, mv(7 8 9=.a)
gen tu=irecode(mbtru, 2)
mean gincdif, over(tu)


******4******
*DO WOMEN WORK LONGER HOURS IN 'FORMAL' EMPLOYMENT THAN MEN (NOTE - I HATE THIS DISTINCTION)

*using hours worked (wkhtot) and gender(gndr) test this hypothesis
label list wkhtot
mvdecode wkhtot, mv(666 777 888 999=.a)
label list gndr
mvdecode wkhtot, mv(9=.a)
tab gndr

*Why might this not tell an accurate story?
