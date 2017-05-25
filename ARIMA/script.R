# First you plot the time series and assess its stationarity
library(forecast)
library(tseries)
plot(Nile)
# Assess presence of a trend in dataset
ndiffs(Nile)

# Since there is a trend, the series is differenced 
# once (lag=1 is the default) and saved as dNile
dNile <- diff(Nile)
# Plot the differenced time series
plot(dNile)
# Applying the ADF test to the differenced series 
# suggest that it’s now stationary, so we can 
# proceed to the next step
adf.test(dNile)

# Identifying one or more reasonable models
# here we examine autocorrelation and partial
# autocorrelation plots for the differenced
# Nile time series
# autocorrelatioin plot
Acf(dNile)
# partial autocorrelation plot
Pacf(dNile)

# Fitting an ARIMA model -------------------------------------
library(forecast)
fit <- Arima(Nile, order = c(0, 1, 1))
fit
# Accuracy measures
accuracy(fit)

# Evaluating model fit ---------------------------------------
# qqnorm produces a normal QQ plot of the values in y. 
# qqline adds a line to a “theoretical”, quantile-quantile plot 
# which passes through the probs quantiles, 
# by default the first and third quartiles
help("qqnorm")
qqnorm(fit$residuals)
qqline(fit$residuals)
# Box.test() function provides a test that autocorrelations 
# are all zero. The results aren ’t significant, suggesting 
# the autocorrelations don ’t differ from zero.
# This ARIMA model appears to fit the data well.
Box.test(fit$residuals, type = "Ljung-Box")

# Forecast 3 years ahead for Nile time series
forecast(fit, 3)
# Plot function shows the forecast. Point estimates are
# given by the blue dots, 80 % and 95 % confidence bands 
# are represented by dark and light bands, respectively
plot(forecast(fit, 3), xlab = "Year", ylab = "Annual Flow")

# Automated ARIMA forecasting -------------------------------
# Comparing the automatic test against our manual method above
library(forecast)
fit <- auto.arima(Nile)
fit

accuracy(fit)
qqnorm(fit$residuals)
qqline(fit$residuals)
Box.test(fit$residuals, type = "Ljung-Box")

plot(forecast(fit, 3), xlab = "Year", ylab = "Annual Flow")
