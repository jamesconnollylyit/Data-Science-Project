# assume from past experience that reaction time has a standard
# deviation of 1.25 seconds. Also suppose that a 1 - second difference in reaction
# time is considered an important difference. You ’d like to conduct a study in which
# you ’re able to detect an effect size of d = 1 / 1.25 = 0.8 or larger.
#Additionally, you want to be 90 % sure to detect such a difference if it exists
# and 95 % sure that you won ’t declare a difference to be significant when 
# actually due to random variability. 
# How many participants will you need in your study?
install.packages("pwr")
library(pwr)
help("pwr")
pwr.t.test(d = .8, sig.level = .05, power = .9, type = "two.sample",
alternative = "two.sided")

# Detect 0.5 SD difference in population menas
# Limit chance of false declaration to be 1 in 100
# We can only inclide 40 participants
# What is probability of detecting a difference
# between populations means that this size with our constraints
pwr.t.test(n = 20, d = .5, sig.level = .01, type = "two.sample",
alternative = "two.sided")

# ANOVA
pwr.anova.test(k = 5, f = .25, sig.level = .05, power = .8)
# The total sample size is therefore 5 × 39, or 195. 
# Note - this example requires you to estimate what the means 
# of the five groups will be, along with the common variance.

# Correlations
pwr.r.test(r = .25, sig.level = .05, power = .90, alternative = "greater")
# you need to assess depression and loneliness in 134 participants 
# to be 90% confident that you’ll reject the null hypothesis if it’s false.

# Linear models
pwr.f2.test(u = 3, f2 = 0.0769, sig.level = 0.05, power = 0.90)

# Tests of proportions
pwr.2p.test(h = ES.h(.65, .6), sig.level = .05, power = .9,
alternative = "greater")

# Chi-square tests
#  matrix constructed by row x 3
prob <- matrix(c(.42, .28, .03, .07, .10, .10), byrow = TRUE, nrow = 3)
prob
# Calculate effect size corresponding to the alternative hypothesis 
# from pur two - way contingency table
ES.w2(prob)
# Using this information we can calculate the necessary sample size like this:
pwr.chisq.test(w = .1853, df = 2, sig.level = .05, power = .9)

# Choosing appropriate effect size in novel situations
library(pwr)
# Sequence starting at 0.1 to 0.5 in sequences of 0.01
effectsize <- seq(.1, .5, .01)
effectsize
# Number of values in effect size
nes <- length(effectsize)

samplesize <- NULL

for (i in 1:nes) {
    result <- pwr.anova.test(k = 5, f = effectsize[i], sig.level = .05, power = .9)
    samplesize[i] <- ceiling(result$n) #store anova calculation in samsize
}

plot(samplesize, effectsize, type = "l", lwd = 2, col = "red",
ylab = "Effect Size",
xlab = "Sample Size (per cell)",
main = "One Way ANOVA with Power=.90 and Alpha=.05")

# Creating power analysis plots
library(pwr)
# uses the seq function to generate a range of effect sizes 
# effectsize (correlation coefficients under H1) and power levels (powerlevels)
effectsize <- seq(.1, .5, .01)
nr <- length(effectsize)
powerlevels <- seq(.4, .9, .1)
np <- length(powerlevels)

# It then uses two for loops to cycle
# through these effect sizes and power levels
# calculating the corresponding sample
# sizes required and saving them in the array samsize

samsize <- array(numeric(nr * np), dim = c(nr, np))
for (i in 1:np) {
    for (j in 1:nr) {
        result <- pwr.r.test(n = NULL, r = effectsize[j],
        sig.level = .05, power = powerlevels[i],
        alternative = "two.sided")
        samsize[j, i] <- ceiling(result$n)
    }
}

# The graph is set up with the
# appropriate horizontal and vertical axes and labels
xrange <- range(effectsize)
yrange <- round(range(samsize))
colors <- rainbow(length(powerlevels))
plot(xrange, yrange, type = "n",
xlab = "Correlation Coefficient (r)",
ylab = "Sample Size (n)")

# Add power curves using lines
for (i in 1:np) {
    lines(effectsize, samsize[, i], type = "l", lwd = 2, col = colors[i])
}

# A grid and legend are added to aid
# reading the graph
abline(v = 0, h = seq(0, yrange[2], 50), lty = 2, col = "grey89")
abline(h = 0, v = seq(xrange[1], xrange[2], .02), lty = 2, col = "gray89")

# Add annotations
title("Sample Size Estimation for Correlation Studies\n
Sig=0.05 (Two-tailed)")
legend("topright", title = "Power", as.character(powerlevels),
fill = colors)