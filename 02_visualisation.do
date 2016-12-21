***************************************************
*WEEK 4, DESCRIBING AND VISUALIZING DATA, SESSION 1
***************************************************

*NOTE: Any non-command (explanatory) text in a Stata do-file is preceded by '*'
*If you want to make a note on a do-file, but no not place * before the text, Stata assumes you are writing a command.
*We can break up long command like this using the /* */ line break feature.

*We will use the international dataset first this week.

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
use international_2009
set more off

*Use the set of basic commands (des; sum; des, d) to browse the dataset contents 

*First, check out the suite of Stata commands through the help menus.
*Click the 'other' option to see other commonly used graphs.

help graph

*REMEMBER - for all that follows, you must choose a graphic appropriate to the variable's level of measurement

***********
*Histograms
***********

*We wil focus on the inequality and government spending

des gini_net expend
sum gini_net expend

hist gini_net, fraction
hist expend, fraction

*The bin option specifies the number of bars in the plot region
*Which of the following two is preferable?
hist gini_net, percent bin(6)
hist gini_net, percent bin(20)

*Add a gap between the bars (useful for discrete variables)
hist gini_net, percent bin(6) gap(10)

*In the following, we first specify the number of bins.
*In the second, we set the bin width, and Stata automatically sets the number of bins.
*Which method is preferable?
hist gini_net, percent bin(6)
hist gini_net, percent width(5)

*We can also add a normal curve to assess the shape of the distribution
hist gini_net, fraction bin(7) normal
hist expend, fraction bin(7) normal
hist open, fraction bin(7) normal

*Use this command to examine the effect of transformation across the ladder of powers
gladder open

*************
*Boxplots
*************

*Boxplots are very useful for inspecting the shape of a distribution
*The line in the middle is the median (how can you get Stata to display the median - remember??)
*The upper and lower boundaries of the box are the first and third quartiles (the height of the box is the interquartile range)
*The upper and lower whiskers are the values 1.5 times the interquartile range from the upper and lower box boundary
*Values appearing in dots are indicative of outliers (extreme values)

graph box open
graph box fdi

*What can you conclude about the above variables?
*For more context, try exploring them with the 'des' and 'sum, d' commands

*Outliers (extreme cases) are an important check to perform in advance of many tests
*The command below generates a boxplot, labelling the outliers by country
graph box fdi, medtype(line)  mark(1, mlabel(country))

*************
*Scatterplots
*************

*The basic scatterplot command is given by:
graph twoway scatter gini_net expend
*Or it's shorter version:
scatter gini_net expend

*The very helpful scatterplot matrix lets us inspect basic correlations very quickly
graph matrix gini_net expend fdi ls_gni
scatter gini_net expend, mlabel(country)

*How would you describe the relationship between inequality and expenditure?
*We can modify the graph with a regression line to help:
graph twoway (scatter gini_net expend) (lfit gini_net expend)
graph twoway (scatter gini_net expend, mlabel(country)) (lfit gini_net expend)

*Check the presentation options available in Stata and experiment with a few options (s2color is default)
help set scheme
set scheme s2mono
graph twoway (scatter gini_net expend) (lfit gini_net expend)
set scheme s1rcolor 
graph twoway (scatter gini_net expend) (lfit gini_net expend)

*Set the theme to Stata Journal format, and produce a histogram of 'open'
*Return the scheme to the default when you are finished
set scheme s2color

*Scatterplots are very commonly used in preliminary analysis.
*Let's examine a few common modifications

*To modify the x and y axis ranges:
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50))
*Is it always best to have scales set to the maximum range of the data?
scatter gini_net expend, xscale(range(0 100)) yscale(range(0 100))

*We can also add reference lines corresponding to the mean of x or y
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50))

sum expend
local expendmean=r(mean)
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50)) xline(42.90798) yline(30.00088 )

*....or change the marker type
help marker_options
scatter gini_net expend, msymbol(plus)

*...or change the colour
scatter gini_net expend, msymbol(plus) mcolor(gold)

*...and label the axes:
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50)) mlabel(country) ytitle("Gini Inequality") xtitle("Government Expenditure")

*...and finally, add a master title
scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50)) /*
*/ mlabel(country) ytitle("Gini Inequality") xtitle("Government Expenditure") /*
*/ title(Inequality and Government Spending) note(Gini Inequality (0-100) and Government Spending (% GDP)) subtitle(2009)



***************************************************
*WEEK 4, DESCRIBING AND VISUALIZING DATA, SESSION 2
***************************************************

*You may also want to save your graphs (remember the graph export command must be run after producing the graph)
*Stata will save in .tif .png
*For mac you can use the .pict format
*Make sure you set your directory first before running the command below (note the use of line breaks also)

scatter gini_net expend, xscale(range(30 60)) yscale(range(20 50)) /*
*/ mlabel(country) ytitle("Gini Inequality") xtitle("Government Expenditure") /*
*/ title(Inequality and Government Spending) note(Gini Inequality (0-100) and Government Spending (% GDP)) subtitle(2009)

graph export inequality1.tif

*Confirm by inspecting the directory contents
dir

*********************************
*Line graphs and time series data
*********************************

*Time series data are data on a case measured at repeated intervals

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
use ireland_time_series.dta

*Stata first needs to be told it is dealing with time series data
tsset year, yearly

*We can explore the data using the basic suite of graph commands
*For time series data these are not strictly suitable, but they give a cursory overview
*Let's take a closer look at spending on benefits
hist benefit, percent width(2)

graph box benefit, medtype(line)  mark(1, mlabel(year))

*Proper graphing of time series data requires that we preserve the time ordering of the data
*We do this by using the 'tsline' command.
*Let's take a look at union membership since 1960

tsline union

*Time series data is especially prone to distortion from axis scaling
*Here is the same graph with the y-axis range set from 0-100
tsline union, yscale(range (0 100)) ylabel(0(20)100)

*In the above command, 'yscale' sets the range of the y axis, and ylabel sets the range and interval of markers
*In 'ylabel', 20 is the delta (interal) and 0  100 are the min and max values. You can vary this as you wish
*Try it with additional variables, and note the effect of the change in scale:
tsline ls_gni
tsline ls_gni, yscale(range (0 100)) ylabel(0(20)100)

tsline mig
tsline mig, yscale(range (-50 50)) ylabel(-50(10)50) xlabel(1960(5)2010)

tsline top1
tsline top1, yscale(range (0 100)) ylabel(0(20)100)

*Which of the above are most useful?

*Connected plots give an icon at each data point
twoway connected ls_gni year, yscale(range (0 100)) ylabel(0(20)100) msize(small)
twoway connected mig year

*We can also add a second variable
tsline union top1
*This kind of plot method is fine for variables measures on the same scale, but what about these:
tsline union trade
*Individually they look like this:
tsline union
tsline trade
*But together they look like this:
tsline union trade

*We need to define two different y-axes for these variables:
twoway (tsline union) (tsline trade, yaxis(2))

***********
*Exercises
***********

******1******

*Plot a connected graph showing the top1% income share and union density, but only from 1990-2005
*Set the x-axis to show two year intervals
*Title the graph "Top Income Inequality and Unionisation (1990-2012)"

twoway connected top1 year if year >=1990 & year <=2005, xlabel(1990(2)2005) title(Top Income Inequality and Unionisation (1990-2012))

******2******

*Generate a line plot of net migration and trade in the same plotspace
*Scale the migration rate axis to a range of -30 to 30, and an interval of 10
*Title the graph "Net Migration Rate and Global Trade Share"
twoway (tsline mig, yscale(range(-30 30)) ylabel(-30(10)30) title(Net Migration Rate and Global Trade Share)) /*
*/(tsline trade, yscale(range (0 2)) yaxis(2))

*****3******

*Sort the data by ls_gni and identify the year that labour's share was at its highest
*Generate a connected plot of ls_gni and add a reference line to the x-axis at the peak year
*Add a note to the graph stating "Labour's share of Gross National Income peaked in xxxx"
*Adjust the y-axis to show from 50 to 80 with an interval of 5
*Save the graph in .tif format and check the directory contents
gsort ls_gni
list ls_gni year
gsort year
twoway connected ls_gni year, xline(1980) yscale(range(50 80)) ylabel(50(5)80) /*
*/note(Labour's share of Gross National Income peaked in 1980) title(Peak Labour Share (1960-2012))
graph export peakls.tif

*************************************************************
*Bar charts (including some cheats using discrete histograms)
*************************************************************

cd "H:\Teaching 2016-2017\SOC40830\Data"
dir
use ESS7IE.dta

*First, lets set up missing codes for a number of variables
label list prtclaie
mvdecode prtclaie, mv(66 77 88 99=.a)
mvdecode lrscale, mv(77 88 99=.a)
mvdecode alcbnge, mv(6 7 9=.a)

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
graph bar lrscale, over(rel_grp2)

*The same information can be represented on a dot chart, which is very simple and effective:
graph dot lrscale, over(rel_grp2)
help graph dot

***********
*Exercises
***********

******1******
*Repeat the bar chart for left-right scale by religiosity above:
graph bar lrscale, over(rel_grp2)
*But this time, use the help dialogs to find out how to add labels to the bars
*We want to label the bars by their height (the value each bar represents)
*Access the help menu as follows:
help graph bar
graph bar lrscale, over(rel_grp2) blabel(bar)

******2******
*Use the histogram method to produce a plot of binge frequency (alcbnge)
label list alcbnge
mvdecode alcbnge, mv(6 7 8 9=.a)
hist alcbnge, percent discrete addlabels xlabel(1(1)5, valuelabel angle(45))
*Repeat the plot over gender
hist alcbnge, percent discrete addlabels xlabel(1(1)5, valuelabel angle(45)) by(gndr)

******3******
*Produce a dot chart for age (agea) over binge drinking (alcbnge)
graph dot agea, over(alcbnge)
*Add a suitable title and notes on the measures to the graph
graph dot agea, over(alcbnge) title(Averages Ages of Respondents by Drinking) ytitle(Mean Age) note(Source: European Social Survey Round 7 (2014))

*************
*Pie charts
*************

*There is no lesson here. Do not ever use a pie chart. 
*If you really must see one, here it is:
graph pie lrscale, over(rel_grp2)
