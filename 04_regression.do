********************************************
*Week 6, Regression (Bivariate and Multiple)
********************************************

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
clear
use ESS7IE
set more off

***************************
*Independent samples t-test
***************************

*Remember the distinction between a paired t-test, and independent samples (groups) t-test

help ttest

*The command you will need to complete the following is 'ttest'
*In practice, it takes the following form, with the grouping variable specified as an option

ttest alcwkdy, by(gndr)

********************
*t-test exercises
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


**************************************
*Bivariate and multivariate regression
**************************************


use international_2009.dta

*First, take a look at the help dialog for the regression command:

help regress
*or
help reg

*The following will reproduce the example used in class
*Let's begin by exploring the relationship between inequality and expenditure

*This useful command produces pearson correlations for any set of specified SCALE variables
pwcorr gini_net service trade expend, sig star(.05)

*This plot command will fit a linear trend to any pair of variables
twoway (scatter gini_net trade) (lfit gini_net trade)
*You can also label the data by location
twoway (scatter gini_net expend, mlabel(cty)) (lfit gini_net expend)
*Finally, we run the regression model
reg gini_net expend
*And finish by plotting the residuals against the fitted values
rvfplot, yline(0) mlabel(cty)


********************************************
*Statistical control and multiple regression
********************************************


*Let's add another variable to the model
reg gini_net expend trade
*We are interpret this result as the effect of expenditure 'controlling for' trade

*To understand how statistical control works, 
*we need to consider the residuals in greater detail.
*First, run a basic bivariate model and store the residuals
reg gini_net expend
predict e_ex, resid
*This gives us the distance from the original value to the predicted (regression line)
*These can be interpreted as the component of inequality that is unrelated to expenditure
*It is 'unexplained variation' in inequality
reg trade expend
predict e_tr, resid
*These residuals reflect the component of variation in
*expenditure that is unrelated to trade.

*We now have two variables:
*e_ex which reflects inequality adjusted for expenditure
*e_tr which reflects expenditure adjusted for trade

*What happens when we regress these on each other?
reg e_ex e_tr
*Take a look at the original regression table if you are unsure
reg gini_net expend trade


***************************************
*Regression assumptions and diagnostics
***************************************

*1. Expected value of the error term is 0.

*The error term (residual) represents that variation in the dependent variable
*unaccounted for by the model
*In practice, it means ensuring that exogenous influences (those not in model)
*cancel each other out.
reg gini_net expend trade
rvfplot, yline(0)
*The overall mean is 0, but the local mean (at each level of the outcome) must also be 0
*Violations of this assumption can be caused by any of issues 1.1-1.4.


*1.1 Linear relationship between DV and IVs.
graph matrix gini_net expend trade
reg gini_net expend trade
*We then use the following commends to fit a smoother to the residual plot
*This can be interpreted (kind of) similarly to a moving average
cprplot expend, msopts(bands(10))
*Try it with trade - how do we know how many bands to set?
*It depends on the number of cases - a higher band will give greater resolution
*in larger datasets, but may be too detailed to be useful for a small dataset
reg gini_net expend trade
cprplot trade, msopts(bands(10))
*Is the local mean 0 for all values of the variable?


*1.2. Absence of influential cases.

*We will explore one method here - dfbeta.
*This method re-runs the model with each observation dropped in turn
*The plot is a plot of all the re-estimated coefficients with each case dropped

reg gini_net expend trade
dfbeta
*Running the dfbeta command returns a variable for each independent variable:
graph box _dfbeta_1 _dfbeta_2, marker(1, mlab(country)) marker(2, mlab(country))
*Which cases are likely to be unduly influencing the results?

*Added variable plots are also very useful
*These are a series of bivariate plots of the regression residuals of:
*The full model minus the variable (x1) against the other remaining variables against (x1)
reg gini_net expend trade
avplots
*Try labelling the points to see what case might be causing problems in the trade variable
avplots, mlabel(cty)

*1.3. No omitted variables.

*A theoretical problem!!! Use your head (and imagination)


*1.4. No multicollinearity.

*Multicolinearity is a high correlation between independent variables.
*It can lead to biased diagnostics - particualrly inflated r^2
*(Register for my time series module to find out why!!!!!!!!!!)
pwcorr gini_net expend trade
*Correlation gives a preliminary indication of trouble, but is not enough alone.
*Variance inflation factors give a bettwe indication
*The VIF should generally not exceed 1, and a mean >10 indicates serious trouble
reg gini_net expend trade, noheader
estat vif


*6. Variance of error terms identical across levels of independent variables (homoscedasticity).

*Homoscedasticity is the property of constant error variance
*Heteroscedasticity is the violation of this requirement.
*How do we assess it?
symplot gini_net
*This command shows us the symmetry of inequality around its median
symplot expend
symplot trade, mlabel(cty)
symplot trade, mlabel(cty)
*The rvfplot gives a good visual indication of this assumption
reg gini_net expend trade
rvfplot, yline(0)
*We can improvie on it by plotting the error variance across different groups of observations
reg gini_net expend trade
predict yhat
predict stud, rstud
local groups=round(e(N)/5,1)
xtile groups=yhat, nq(`groups')
graph box stud, over(groups)

*Seroious problems!


*7. Errors must be uncorrelated.

*A greater issue in time series data, but still important.
*We can usually adjust for some confounding factors by applying weights
*We will explore this in the context of the ESS survey dataset


*********************************************************************
*A more elaborate example of multiple regression with individual data
*********************************************************************

use ESS7IE
set more off

*What influences the levels of trust people have in others?
*There are three questions we can use in the ESS to help us answer this.
des ppltrst pplfair pplhlp
label list ppltrst pplfair pplhlp
*As ever, take care of the missing value codes
mvdecode ppltrst pplfair pplhlp, mv(77 88 99=.a)
*And create a new scale composed of the mean of the three items
alpha ppltrst pplfair pplhlp, gen(trust) d
*We now have a new scale variable measuring levels of trust
*What variables might explain levels of trust?
*You can probably identify many, but we will begin with some simple controls:
des agea
des rlgblg
des happy
des gndr
des dscrgrp
des brncntr
*As usual, go through the missing values! 
*Just run the following lines of code if you wish
label list agea
mvdecode agea, mv(999=.a)
label list rlgblg
mvdecode rlgblg, mv(7 8 9=.a)
tab rlgblg
label list happy
mvdecode happy, mv(77 88 99=.a)
label list gndr
mvdecode gndr, mv(9=.a)
tab gndr
label list dscrgrp
mvdecode dscrgrp, mv(7 8 9=.a)
tab dscrgrp
label list brncntr
mvdecode brncntr, mv(7 8 9=.a)
tab brncntr

*Now, let's examine the contribution of the variables
*We usually do this in blocs, starting with key predictors
*We then add controls progressively to examine changes in the effect of variables of interest, controlling for other characteristics
*Let's say our research question concerns the role of gender in explaining levels of trust
reg trust i.gndr
estimates store m1
*Note, the 'i.' tells stata we are dealing with a categorical variable
reg trust i.gndr agea
estimates store m2
*Now let's try a fully specified model
reg trust i.gndr agea i.rlgblg happy i.gndr i.dscrgrp i.brncntr
estimates store m3

*What do you conclude?
*We can plot the model output side by side to make assessment easier
estimates table m1 m2 m3, stats(N r2_a) star(.05 .01 .001)


*******************************
*Regression exercises
*******************************


*1
*What is the relationship between labour's share of GNI (ls_gni) and foreign direct investment (fdi)?
*Produce a plot of the residuals vs fitted values, and label the points by country (cty)

*2
*Switch to the ESS data
use ESS7IE, clear
*What is the relationship between gender (gndr) and political orientation (lrscale)?
label list lrscale
label list gndr
mvdecode lrscale, mv(9=.a)
mvdecode lrscale, mv(77 88 99=.a)

*3
*Try running the model again with a categorical religion variable
label list rlgdgr
mvdecode rlgdgr, mv(77 88 99=.a)
gen relgrp = irecode(rlgdgr, 2, 6, 10)
