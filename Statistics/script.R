# From previous lecture slides
install.packages('faraway')
library(faraway)
data(orings)
# attaching the 'orings' dataset:
attach(orings)
# Now the columns of the data frame can be referred to by name.
# To see the data, type the name of the data object:
orings
detach(orings)
plot(damage / 6 ~ temp, data = orings, xlim = c(25, 85), ylim = c(0, 1), xlab = "Temperature", ylab = "Prob of damage")
lmod <- lm(damage / 6 ~ temp, data = orings)
abline(lmod)


# Descriptive statistics ----------------------------------------------
# we’ll look at measures of central tendency, variability
# and distribution shape for continuous variables
myvars <- c("mpg", "hp", "wt")
head(mtcars[myvars])

# Summary statistics
# provides the minimum, maximum, quartiles, and 
# mean for numerical variables and frequencies 
# for factors and logical vectors
myvars <- c("mpg", "hp", "wt")
summary(mtcars[myvars])

# Descriptive statistics via sapply()
# myvars lists our variable of interest from mtcars
myvars <- c("mpg", "hp", "wt")

# Our function that accepts in data (x)
# and outputs it as mean, no of values, SD
# skew and Kurtosis value
# Use sapply(mtcars[myvars], mystats, na.omit=TRUE)
# if you want to omit missing values

# Note - see notes for explanation on 
# skewness and Kurtosis
mystats <- function(x, na.omit = FALSE) {
    if (na.omit)
        x <- x[!is.na(x)] # omit missing values
    m <- mean(x)
    n <- length(x) #no of values in x
    s <- sd(x) #SD of all values in each column
    skew <- sum((x - m) ^ 3 / s ^ 3) / n
    kurt <- sum((x - m) ^ 4 / s ^ 4) / n - 3
    return(c(n = n, mean = m, stdev = s, skew = skew, kurtosis = kurt))
}


# sapply(x, FUN, options) where x is the 
# data frame (or matrix) and FUN is an arbitrary function
head(mtcars)
sapply(mtcars[myvars], mystats)

# Results show mean mpg is 20.1, with a SD of 6.0. 
# The distribution is skewed to the right(+0.61) 
# and is somewhat flatter than a normal distribution (–0.37).
# See notes for details on skew and Kurtosis

# Show mpg graphically
d <- density(mtcars$mpg)
plot(d)
# Show mean mpg
abline(v = 20, lty = 2, col = "blue")

# Using R client 3.3.2.0
install.packages("Hmisc") # note it is case sensitive
library(Hmisc)
myvars <- c("mpg", "hp", "wt")
# describe() function in the Hmisc package returns 
# the number of variables and observations
# the number of missing and unique values
# the mean, quantiles, and the five highest and lowest values.
describe(mtcars[myvars])
is.na(mtcars[myvars])

# pastecs package includes a function 
# named stat.desc() that provides a wide
# range of descriptive statistics.
install.packages("pastecs")
library(pastecs)
myvars <- c("mpg", "hp", "wt")
# the number of values, null values, missing values, 
# minimum, maximum, range, and sum are provided

# also show skewness, Kurtosis, Shapiro-Wilk test
# of normality
stat.desc(mtcars[myvars], norm = TRUE)



# the psych package also has a function called describe() that
# provides the number of nonmissing observations, mean, sd, median,
# trimmed mean, median absolute deviation (mad), minimum, maximum, 
# range, skew, kurtosis, and standard error of the mean

install.packages("psych")
library(psych)
myvars <- c("mpg", "hp", "wt")
describe(mtcars[myvars])

# Descriptive statistics by group using aggregate() ---------------
# When comparing groups of individuals or observations
# the focus is usually on the descriptive statistics of each group
# rather than the total sample

myvars <- c("mpg", "hp", "wt")
# Note the use of list(am=mtcars$am)
# If you used list(mtcars$am), the am column
# would be labeled Group.1 rather than am.
aggregate(mtcars[myvars], by = list(am = mtcars$am), mean)

# Aggregate won’t return several statistics at once
# single-value functions only eg mean, sd
# We use the by() function for several outputs
# using a function that operates on all columns of
# a data frame
dstats <- function(x) sapply(x, mystats)
myvars <- c("mpg", "hp", "wt")
# Here we're applying the mystats function
# to each column of the data frame.
# Placing it in the by() function gives 
# you summary statistics for each level of am.
# Remember - am  = 0 for automatic
# or 1 for manual transmission
by(mtcars[myvars], mtcars$am, dstats)

doBy - -------------------------------------------

# doBy provide functions for descriptive statistics by group
install.packages("doBy")
library(doBy)
# Variables on the left of the ~ are the numeric variables 
# to be analysed, and variables on the right are categorical 
# grouping variables
# Uses the mystats function defined earlier
summaryBy(mpg + hp + wt ~ am, data = mtcars, FUN = mystats)

# frequency and contingency tables from categorical variables

# Contingency tables tell you the frequency or proportions
# of cases for each combination of the variables that make up the table

describeBy() - ---------------------------------------
library(psych)
myvars <- c("mpg", "hp", "wt")
# DescribeBy() doesn’t allow you to specify
# an arbitrary function, so it ’s less generally applicable
describeBy(mtcars[myvars], list(am = mtcars$am))

# Frequency and contingency tables ---------------------
library(vcd)
# Show top of structure
head(Arthritis)
# Treatment, sex, and improved are categorical factors
str(Arthritis)

# one-way table ----------------------------------------
# simple frequency counts using the table() function
mytable <- with(Arthritis, table(Improved))
mytable

# Turn these frequencies into proportions
# Expresses table entries as fractions of the 
# marginal table defined by the margins
# In this example we dont have a representation for margins
prop.table(mytable)

# Expressed as percentages
# 50% of study participants had some or marked improvement
prop.table(mytable) * 100

# two-way tables -------------------------------------------
# use syntax mytable <- table(A, B)
# where A is the row variable and B is the column variable

# Alternatively use xtabs() ---------------------------------
# the variables to be cross-classified appear on the right 
# of the formula (that is, to the right of the ~) separated by + signs
# If variable is included on the left side of the formula, 
# it’s assumed to be a vector of frequencies 
# (useful if the data have already been tabulated).
mytable <- xtabs(~Treatment + Improved, data = Arthritis)
mytable

# generate marginal frequencies
# for mytable
# The index (1) refers to the first variable 
# in the table() statement
# This means proportional table by index (1)
# examines proportions by treatment
# and index (2) examines improved proportions
margin.table(mytable, 1)

# Looking at the table, we can see that 51% of treated 
# individuals had marked improvement, compared to 16% 
# of those receiving a placebo.
prop.table(mytable, 1)

# For colum sums and proportions we use the same
# commands but examine the second variable in
# the table() statement
# Note - 1st variable = rows, 2nd variable = columns
# Here, the index (2) refers to the second 
# variable in the table() statement.
margin.table(mytable, 2)
prop.table(mytable, 2)
# Cell proportions obtained using this statement
prop.table(mytable)

# addmargins() function to add marginal sums 
# to these tables. For example, the following 
# code adds a Sum row and column:
addmargins(mytable)

# Add marginal sums to proportion table
addmargins(prop.table(mytable))

# default is to create sum margins for all 
# variables in a table. 
# The following code adds a Sum column alone
addmargins(prop.table(mytable, 1), 2)
# Similarly, this code adds a Sum row:
addmargins(prop.table(mytable, 2), 1)
# 25% of those patients with marked improvement received a placebo


# CrossTable() function -------------------------

install.packages("gmodels")
library(gmodels)
# options to report percentages (row, column, and cell) 
# specify decimal places; produce chi-square, Fisher, 
# and McNemar tests of independence; report expected 
# and residual values (Pearson, standardised, and adjusted 
# standardised) include missing values as valid; annotate 
# with row and column titles; and format as SAS or SPSS style output
help(CrossTable)
CrossTable(Arthritis$Treatment, Arthritis$Improved)

# Multidimensional tables ---------------------------------------
# This code produces cell frequencies for the three-way 
# classification. 
# Treatment and Sex are shown in 2 dimensional table
# for each state of Improved
mytable <- xtabs(~Treatment + Sex + Improved, data = Arthritis)
mytable
help(xtabs)

# This code demonstrates how the ftable()
# function can be used to print a more compact
# version of the table.
ftable(mytable)

# The code in this section produces the marginal frequencies for Treatment, Sex, and
# Improved. Because you created the table with the formula ~ Treatment + Sex +
# Improved, Treatment is referred to by index 1
# Sex is referred to by index 2, and Improved is referred to by index 3.

# Marginal frequencies by treatment
margin.table(mytable, 1)

# marginal frequencies by sex
margin.table(mytable, 2)

# marginal frequencies by Improved
margin.table(mytable, 3)

# This code produces the marginal frequencies 
# for the Treatment x Improved
# classification, summed over Sex.
# See earlier ftable() output for 
# explanation of results
margin.table(mytable, c(1, 3))

# The proportion of patients with None, Some, and
# Marked improvement for each Treatment × Sex 
# combination is provided
ftable(prop.table(mytable, c(1, 2)))

# 36% of treated males had marked improvement, compared to 59% of
# treated females. In general, the proportions will add to 1 over the indices not
# included in the prop.table() call(the third index, or Improved in this case) . You can
# see this in the last example, where you add a sum margin over the third index (Improved)
ftable(addmargins(prop.table(mytable, c(1, 2)), 3))

# percentages instead of proportions, you can multiply the resulting
# table by 100. For example, this statement
ftable(addmargins(prop.table(mytable, c(1, 2)), 3)) * 100

# Tests of independence ------------------------------------------

# Chi-square test of independence
library(vcd)
mytable <- xtabs(~Treatment + Improved, data = Arthritis)
chisq.test(mytable)
# there appears to be a relationship between treatment received 
# and level of improvement as represented by the p value (p < .01)

# Test relationship between patient sex and improvement.......
mytable <- xtabs(~Improved + Sex, data = Arthritis)
chisq.test(mytable)
# there doesn’t appear to be a relationship
# between patient sex and improvement(p > .05)

# Error caused because one of the six cells in the table 
# (male-some improvement) has an expected value less than five
# which may invalidate the chi-square approximation
mytable

# Fisher's exact test
# Fisher’s exact test evaluates the null hypothesis of 
# independence of rows and columns in a contingency table with 
# fixed marginals - 2 way table only
mytable <- xtabs(~Treatment + Improved, data = Arthritis)
fisher.test(mytable)


# Chochran-Mantel-Haenszel test
# test of the null hypothesis that two nominal variables 
# are conditionally independent in each layer of a third variable. 

# results suggest that the treatment received and the improvement 
# reported aren’t independent within each level of Sex 
# (that is, treated individuals improved more than those 
# receiving placebos when controlling for their gender).
mytable <- xtabs(~Treatment + Improved + Sex, data = Arthritis)
mantelhaen.test(mytable)
mytable


# Measures of association for a two-way table
# calculate the phi coefficient (also known as mean square contingency coefficient)
# contingency coefficient, and Cramer’s V significance

# Larger magnitudes indicate stronger associations
# small p value indicate relationship
library(vcd)
mytable <- xtabs(~Treatment + Improved, data = Arthritis)
assocstats(mytable)

# Correlations ----------------------------------------------------
# Covariances and correlations
state.x77
states <- state.x77[, 1:6]
states

# the cov function to provide covariances only. Covariance is a measure 
# of how much two random variables vary together. # It’s similar to variance
# but where variance tells you how a single variable varies, covariance 
# tells you how two variables vary together
cov(states)

# Pearson product-moment correlation coefficients. Pearson is a measure 
# of the linear correlation between two variables X and Y. It has a value 
# between +1 and ?1, where 1 is total positive linear correlation, 0 is no 
# linear correlation, and ?1 is total negative linear correlation.
cor(states)

cor(states, method = "spearman")

# producing non-square matrices -------------------------------------
x <- states[, c("Population", "Income", "Illiteracy", "HS Grad")]
y <- states[, c("Life Exp", "Murder")]
cor(x, y)


# partial correlations
install.packages("ggm")
library(ggm)
# partial correlation of population and murder rate, controlling
# for income, illiteracy rate, and HS graduation rate
# Eg pcor statement is using columns 1 (population) and 5 (murder rate)
# controlling for the influence of income, illiteracy rate, and high school
# graduation rate (variables 2, 3, and 6 respectively

pcor(c(1, 5, 2, 3, 6), cov(states))

# Testing a correlation coefficient for significance
# tests the null hypothesis that the Pearson correlation 
# between life expectancy (column 4) and murder rate (column 5) is 0
cor.test(states[, 4], states[, 5])

# Correlation matrix and tests of significance via cor.test
# The "use =" options can be "pairwise" or "complete" 
# for pairwise or listwise deletion of missing values, respectively
# The method= option is "pearson" (the default), "spearman", or "kendall". 

# Correlation and significance levels for matrices of Pearson, 
# Spearman, and Kendall correlations
library(psych)
corr.test(states, use = "complete")
# Here you see that the correlation between population size and high school 
# graduation rate (–0.10) is not significantly different from 0 (p = 0.5) 

# t test ------------------------------------
UScrime
library(MASS)
UScrime$Prob
UScrime$So
# Prob = numberic variable from UScrime dataset (probability of imprisonment)
# So = dichotomous variable (variable with 2 categories)
# So = grouping variable -> s0 = 1 is a Southern state
# and So = 0 is a non-Southern state
t.test(Prob ~ So, data = UScrime)
# We reject the hypothesis that Southern states and non-Southern states 
# have equal probabilities of imprisonment (p < .001)

# dependent t test ---------------------------------------------
# Is the unemployment rate for younger males (14–24) 
# greater than for older males (35–39)
# In this case the 2 groups are related - unemployemnt affects both groups
# Assumption is that 
sapply(UScrime[c("U1", "U2")], function(x)(c(mean = mean(x), sd = sd(x))))
with(UScrime, t.test(U1, U2, paired = TRUE))

# Nonparametric tests of group differences ----------------------------------
# Wilcoxon two group comparison
# apply the (Mann–Whitney) U test to the question of incarceration 
# rates from the previous section
with(UScrime, by(Prob, So, median))
wilcox.test(Prob ~ So, data = UScrime)

# Unemployment question using the Wilcoxon signed rank test as 
# a nonparametric alternative to the dependent sample t-test
sapply(UScrime[c("U1", "U2")], median)
with(UScrime, wilcox.test(U1, U2, paired = TRUE))

# Comparing more than 2 groups
# Kruskal Wallis test
# Kruskal–Wallis test applied to the illiteracy question. First, we’ll have to
# add the region designations to the dataset. These are contained in the dataset
# state.region distributed with the base installation of R
states <- data.frame(state.region, state.x77)
state.region
state.x77
states
# Now we can apply the test:
kruskal.test(Illiteracy ~ state.region, data = states)
