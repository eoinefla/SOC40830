********************************************
*Week 6, Regression (Bivariate and Multiple)
********************************************
set more off
cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
clear
use international_2009, clear


*****************************
*A note on heteroscedasticity
*****************************


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
*Alternatively, we can use the Breusch-Pagan test Ho Constant Variance
reg gini_net expend trade
hettest
*Seroious problems!

*************************************
*A full multivariate regression model
*************************************

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


*********************************
*A note on categorical predictors
*********************************

*Categorical predictors cannot be treated the same as scale variables
*From the example above, let's examine another variable: health
label list health
mvdecode health, mv(7 8 9=.a)
reg trust i.gndr agea i.rlgblg happy i.gndr i.dscrgrp i.brncntr i.health

*In the example above, the coefficients on health are read as relative to 'Very Good'.
*What if we want to change the base category?
reg trust i.gndr agea i.rlgblg happy i.gndr i.dscrgrp i.brncntr ib(#5).health
*Now, the health results are relative to 'Very Bad' - what do you notice?


***************************************************************************
*Final session - conditional effects  (p321) & Intro to Logistic Regression
***************************************************************************

