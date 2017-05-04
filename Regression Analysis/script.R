#  Example shown in slides for Regression Analysis
height <- c(63, 64, 66, 69, 69, 71, 71, 72, 73, 75)
weight <- c(127, 121, 142, 157, 162, 156, 169, 165, 181, 208)
mydata <- data.frame(height = height, weight = weight)
mydata
fit <- lm(weight ~ height, data = mydata)

summary(fit)

# predict weight from height.
# Having an equation for
# predicting weight from height can help
# you to identify overweight or
# underweight individuals.
fit <- lm(weight ~ height, data = women)
summary(fit)
# Because a height of 0 is impossible, you wouldn’t 
# try to give a physical interpretation
# to the intercept. It merely becomes an adjustment constant

# Actual values
women$height

# list the predicted values in the fitted model
fitted(fit)

# List the residual values in the fitted model
residuals(fit)
# show scatter plot 
plot(women$height, women$weight, xlab = "Height (in inches)", ylab = "Weight (in pounds)")
# Add regression line
abline(fit)
# From the Pr(>|t|) column,
# you see that the regression coefficient(3.45) is significantly different from zero
# (p < 0.001) indicates that there’s an expected increase of 3.45 pounds of weight
# for every 1 inch increase in height.
# multiple R-squared is also the squared correlation between the actual 
# and predicted value
# The residual standard error (1.53 pounds) can be thought of as the 
# average error in predicting weight from height using this model.


# Polynomial regression -----------------------------------------------
fit2 <- lm(weight ~ height + I(height ^ 2), data = women)
summary(fit2)
# The prediction equation now is 
# Weight = 261.88 - 7.35 × Height + 0.083 × Height2

# The curve provides a better fit
plot(women$height, women$weight, xlab = "Height (in inches)", ylab = "Weight (in lbs)")
lines(women$height, fitted(fit2))

# this enhanced plot provides the scatter plot of weight with height, 
# box plots for each variable in their respective margins, the linear 
# line of best fit, and a smoothed fit line. 
# spread=FALSE suppresses spread and asymmetry information. 
# smoother.args=list(lty=2) specifies the fit be rendered as a dashed line. 
# pch = 19 options display points as filled circles(the default is open circles) . 
# You can tell that the two variables are roughly symmetrical and that a curved line
# will fit the data points better than a straight line
install.packages("car")
library(car)
scatterplot(weight ~ height, data = women,
  spread = FALSE, smoother.args = list(lty = 2), pch = 19,
  main = "Women Age 30-39",
  xlab = "Height (inches)",
  ylab = "Weight (lbs.)")

# use the state.x77 dataset in the base package for this example. Suppose you
# want to explore the relationship between a state’s murder rate and other characteristics
# of the state, including population, illiteracy rate, average income, and frost levels
# Note ... lm() function requires a data frame (and the state.x77 dataset is
# contained in a matrix) so we can convert it with this code

# A good first step in multiple regression is to examine the 
# relationships among the variables two at a time. 
# The bivariate correlations are provided by the cor() function,
# and scatter plots are generated from the scatterplotMatrix() 
# function in the car package
states <- as.data.frame(state.x77[, c("Murder", "Population",
"Illiteracy", "Income", "Frost")])
cor(states)
library(car)
help(scatterplotMatrix)
scatterplotMatrix(states, spread = FALSE, smoother.args = list(lty = 2),
main = "Scatter Plot Matrix")

states <- as.data.frame(state.x77[, c("Murder", "Population",
"Illiteracy", "Income", "Frost")])
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost,
data = states)
summary(fit)

# Multiple linear regression with interactions -----------------------
# We use : to indicate an interaction between predictor variables
fit <- lm(mpg ~ hp + wt + hp:wt, data = mtcars)
summary(fit)
# Pr(>|t|) column that the interaction between horsepower and
# car weight is significant. What does this mean ? A significant interaction between two
# predictor variables tells you that the relationship between one predictor and the
# response variable depends on the level of the other predictor

# You can visualise interactions using the effect() function in the effects package.
# This means we can change values for wt and view the change graphically
install.packages("effects")
library(effects)
plot(effect("hp:wt", fit,, list(wt = c(2.2, 3.2, 4.2))), multiline = TRUE)

# evaluating the statistical assumptions in a regression analysis. 
# The most common approach is to apply the plot() function
# to the object returned by the lm() . Doing so produces four graphs that are useful
# for evaluating the model fit.
fit <- lm(weight ~ height, data = women)
# 4 plots in one graph
par(mfrow = c(2, 2))
plot(fit)

# Diagnostic plots for the quadratic fit.
fit2 <- lm(weight ~ height + I(height ^ 2), data = women)
par(mfrow = c(2, 2))
plot(fit2)

# Dropping point 13 and 15
newfit <- lm(weight ~ height + I(height ^ 2), data = women[-c(13, 15),])
par(mfrow = c(2, 2))
plot(newfit)

# let ’s apply the basic approach to the states multiple regression problem
states <- as.data.frame(state.x77[, c("Murder", "Population",
                                    "Illiteracy", "Income", "Frost")])
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = states)
par(mfrow = c(2, 2))
plot(fit)
# the model assumptions appear to be well satisfied
# with the exception that Nevada is an outlier

# Global validation of linear model assumption
install.packages("gvlma")
library(gvlma)
gvmodel <- gvlma(fit)
summary(gvmodel)

library(car)
states <- as.data.frame(state.x77[, c("Murder", "Population",
"Illiteracy", "Income", "Frost")])
fit <- lm(Murder ~ Population + Illiteracy + Income + Frost, data = states)
qqPlot(fit, labels = row.names(states), id.method = "identify",
simulate = TRUE, main = "Q-Q Plot")