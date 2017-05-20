# Example time series object
sales <- c(18, 33, 41, 7, 34, 35, 24, 25, 24, 21, 25, 20,
22, 31, 40, 29, 25, 21, 22, 54, 31, 25, 26, 35)
# Use ts() function to create a time-series object
# which represents monthly sales figures for 2 years
# starting at Jan 2003
tsales <- ts(sales, start = c(2003, 1), frequency = 12)
# View contents
tsales
# Show basic plot of the time series
plot(tsales)
# Return time series properties
start(tsales)
end(tsales)
frequency(tsales)
# use the window() function to create a new time 
# series that’s a subset of the original
tsales.subset <- window(tsales, start = c(2003, 5), end = c(2004, 6))
tsales.subset
# Simple moving averages ---------------------------------------
install.packages("forecast")
library(forecast)
# Show a basic plot of time series
plot(Nile, main = "Raw time series")
# Show raw data alongside smoothed
# data using k = 3, 7 and 15.
opar <- par(no.readonly = TRUE)
par(mfrow = c(2, 2))
# min and max values of Nile
ylim <- c(min(Nile), max(Nile))
# Show raw data
plot(Nile, main = "Raw time series")
# Show data with smoothing averages when k = 3
plot(ma(Nile, 3), main = "Simple Moving Averages (k=3)", ylim = ylim)
# Show data with smoothing averages when k = 7
plot(ma(Nile, 7), main = "Simple Moving Averages (k=7)", ylim = ylim)
# Show data with smoothing averages when k = 15
plot(ma(Nile, 15), main = "Simple Moving Averages (k=15)", ylim = ylim)
par(opar)





# Seasonal decomposition using stl() -----------------------------------
# Using time series AirPassengers comes with a base R installation and
# describes the monthly totals(in thousands) of international airline 
# passengers between 1949 and 1960
plot(AirPassengers)
# Log of airpassesngers used to transform additive data to 
# multiplicative data for use with stl() function 
lAirPassengers <- log(AirPassengers)
plot(lAirPassengers, ylab = "log(AirPassengers)")

# A seasonal decomposition (decomposes into seasonal, trend and irregular) 
# is performed and saved in an object called fit
fit <- stl(lAirPassengers, s.window = "period")
# Plotting the results shows the time series, 
# seasonal, trend, and irregular components
# from 1949 to 1960. Note that the seasonal components 
# have been constrained to remain the same across each year (using the 
# s.window="period" option). The trend is increasing, 
# and the seasonal effect suggests more passengers in the
# summer(perhaps during holidays). The grey bars on the right are magnitude
# guides — each bar represents the same magnitude. 
# This is useful because the y - axes are different for each graph.
plot(fit)
# stl() function contains a component called
# time.series that contains the trend, season
# and irregular portion of each observation
# This line displays the logged time series
fit$time.series
# converts the decomposition back to the original metric
exp(fit$time.series)

# Monthplot() and seasonplot() functions displays the subseries 
# for each month (all January values connected, all February values 
# connected, and so on), along with the average of each subseries
par(mfrow = c(2, 1))
library(forecast)
monthplot(AirPassengers, xlab = "", ylab = "")
seasonplot(AirPassengers, year.labels = "TRUE", main = "")

# Simple exponential smoothing example ----------------------
library(forecast)
plot(nhtemp)

# 1-step ahead forecast using the ses() function
library(forecast)
# ets function contains 3 letters for model type
# first letter = the error type 
# second letter = the trend type
# third letter = the seasonal type
# Here we are using a simple model
# with no trend or seasonal components
# checking level only - see table on slide 46
fit <- ets(nhtemp, model = "ANN")
fit
# Forecast function -------------------------------
# forecast() function is used to predict the time series k steps 
# into the future. The format is forecast(fit, k)
# The 1-step ahead forecast for this series is 51.9°F
# with a 95 % confidence interval(49.7 °F to 54.1 °F)
forecast(fit, 1)

# The time series, the forecasted value, and the 
# 80 % and 95 % confidence intervals are plotted here
plot(forecast(fit, 1), xlab = "Year",
ylab = expression(paste("Temperature (", degree * F, ")",)),
main = "New Haven Annual Mean Temperature")

# The mean error and mean percentage error may not be that useful
# because positive and negative errors can cancel out. 
# The RMSE gives the square root of the mean square error
# which in this case is 1.13°F. 
# The mean absolute percentage error reports the error as a 
# percentage of the time - series values. It’s unitless and can 
# be used to compare prediction accuracy across time series. 
# But it assumes a measurement scale with a true zero point
# for example, number of passengers per day. 
# Because the Fahrenheit scale has no true zero, you can ’t use it here. 
# The mean absolute scaled error is the most recent accuracy measure 
# and is used to compare the forecast accuracy across
# time series on different scales. 
# There is no one best measure of predictive accuracy.
# The RMSE is certainly the best known and often cited.
accuracy(fit)

# Holt-Winters exponential smoothing------------------------
library(forecast)
# Here the model contains errors 
# with trend and seasonal components
# see slide 46
fit <- ets(log(AirPassengers), model = "AAA")
fit
# Using forecast() to produce predictions
# for next 5 months
pred <- forecast(fit, 5)
pred
# Lets show our predictions on a plot
plot(pred, main = "Forecast for Air Travel",
ylab = "Log(AirPassengers)", xlab = "Time")

# Now we create a single table using cbind
# to bring together the point forecasts
# with pred$lower and pred$upper containing
# the 80% and 95% lower and upper confidence
# limits, respectively.
# The exp() function is used to return the predictions 
# to the original scale
pred$mean <- exp(pred$mean)
pred$lower <- exp(pred$lower)
pred$upper <- exp(pred$upper)
pred_table <- cbind(pred$mean, pred$lower, pred$upper)
dimnames(pred_table)[[2]] <- c("mean", "Lo 80", "Lo 95", "Hi 80", "Hi 95")
pred_table

# Automatic exponential forecasting with ets()
library(forecast)
# ets - Fits an exponential smoothing model 
# Includes the ability to automate the selection of a model
fit <- ets(JohnsonJohnson)
fit

# Lets plot the next eight quarters (the default)
# flty parameter sets the line type for the forecast line
# (dashed in this case)
plot(forecast(fit), main = "Johnson & Johnson Forecasts",
ylab = "Quarterly Earnings (Dollars)", xlab = "Time", flty = 2)

# frequency means the period of the seasonality. 
# i.e., frequency = frequency of observations per season. 
# In this case, the "season" is one day. So we want
# to show 1 reading per 60 minutes which would be...
mydata <- read.csv("logs.csv") # csv file of data separated by frequency = 60
# That is, this would represent each day as the number of days 
# since 1970-01-01 
myts <- ts(mydata[-1], start = as.Date("2017-05-17"), frequency = 60)
myts
plot(myts)
start(myts)
end(myts)

# zoo library does not require that all hours be present nor
# that the days be consecutive
library(zoo)
install.packages("chron")
library(chron)
z <- zoo(mydata[-1], as.chron(format(mydata$Date), "%d.%m.%Y") + mydata$hour / 24)
z