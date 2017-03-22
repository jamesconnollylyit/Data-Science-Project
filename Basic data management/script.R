# You can create a data frame containing the data 
# in the table using the following code

manager <- c(1, 2, 3, 4, 5)
date <- c("10/24/08", "10/28/08", "10/1/08", "10/12/08", "5/1/09")
country <- c("US", "US", "UK", "UK", "UK")
gender <- c("M", "F", "F", "M", "F")
age <- c(32, 45, 25, 39, 99)
q1 <- c(5, 3, 3, 3, 2)
q2 <- c(4, 5, 5, 3, 2)
q3 <- c(5, 2, 5, 4, 1)
q4 <- c(5, 5, 5, NA, 2)
q5 <- c(5, 5, 2, NA, 1)
# Examine what stringsAsFactors = FALSE does in data.frame
help(data.frame)
# should character vectors be converted to factors?
leadership <- data.frame(manager, date, country, gender, age,
                         q1, q2, q3, q4, q5, stringsAsFactors = FALSE)
# Examine leadership structure
str(leadership)

# Given data frame called mydata, with variables x1 and x2
# and we want to create a new variable sumx that adds these 
# two variables and a new variable called meanx that averages the two variables

# 3 methods
mydata <- data.frame(x1 = c(2, 2, 6, 4), x2 = c(3, 4, 2, 8))
# Integrate sumx and meanx into mydata data frame
mydata$sumx <- mydata$x1 + mydata$x2
mydata$meanx <- (mydata$x1 + mydata$x2) / 2
mydata

# method 2
attach(mydata)
mydata$sumx <- x1 + x2
mydata$meanx <- (x1 + x2) / 2
detach(mydata)

# Method 3
# transform() function simplifies inclusion into the data frame 
# and saves the results to it. Multiple new values can be added
help(transform)
mydata <- transform(mydata,
                    sumx = x1 + x2,
                    meanx = (x1 + x2) / 2)

# 3rd method is best way to go

#Recoding variables ------------------------------------------------
# recode the value 99 for age to indicate that the value is missing
# Only make the assignment when the condition is TRUE
leadership # show layout pre-change
leadership$age[leadership$age == 99] <- NA
leadership
# we can then use the following code to create the agecat variable
# We include the data-frame names in leadership$agecat to ensure that 
# the new variable is saved back to the data frame
leadership$agecat[leadership$age > 75] <- "Elder"
leadership$agecat[leadership$age >= 55 &
leadership$age <= 75] <- "Middle Aged"
leadership$agecat[leadership$age < 55] <- "Young"
# Note - if we hadn’t recoded 99 as missing for age first, 
# manager 5 would’ve erroneously been given the value “Elder” for agecat
leadership

# Alternative (and better) way to write this code
# Within() allows us to modify the data frame
# agecat is a character variable; you’re likely to want to turn it into an ordered factor
leadership <- within(leadership, {
    agecat <- NA
    agecat[age > 75] <- "Elder"
    agecat[age >= 55 & age <= 75] <- "Middle Aged"
    agecat[age < 55] <- "Young"
})

# See notes for additional methods for recoding variables

# Changing variable names -------------------------------------------------------------
# we want to change the variable manager to managerID and date to testDate
fix(leadership)

leadership #check if fixes were applied
# Programmatically using Names() function
names(leadership)
names(leadership)[2] <- "testDate"
leadership
# Bulk change
names(leadership)[6:10] <- c("item1", "item2", "item3", "item4", "item5")
leadership

# Check for missing values ----------------------------------------------------------------
# Eg
y <- c(1, 2, 3, NA)
is.na(y)
# Returns an object of the same size

# leadership example – check if some selected values in leadership contain NA
# Limit data frame search to colums 6-10
is.na(leadership[, 6:10])

# We can't use comparison operators eg myvar == NA is never TRUE
# R doesn’t represent infinite or impossible values as missing values
# These values - use is.infinite() or is.nan().
is.infinite(y)
is.nan(y)

# Excluding missing values  ---------------------------------------------------------------

x <- c(1, 2, NA, 3)
y <- x[1] + x[2] + x[3] + x[4]
z <- sum(x)
x

# We can remove the missing values using na.rm=TRUE option 
x <- c(1, 2, NA, 3)
y <- sum(x, na.rm = TRUE)
y

help(sum) # view how it handles missing data
# We can remove any observation with missing data by using the na.omit() function
# Lets apply this to the leadership dataset
# Reminder of layout
leadership

# Create new a new data frame called newdata and put 
# into it only the rows that do not contain missing data - listwise deletion
newdata <- na.omit(leadership)
newdata
# Use with caution -  listwise deletion can exclude a substantial percentage of your data

# Date values entered into R as character strings and then translated into 
# date variables that are stored numerically.

# The default format for inputting dates is yyyy - mm - dd
# Eg - converts the character data to dates using this default format

mydates <- as.Date(c("2007-06-22", "2004-02-13"))
mydates
# Alternative - 
strDates <- c("01/05/1965", "08/16/1975")
dates <- as.Date(strDates, "%m/%d/%Y")
dates
# reads the data using a mm / dd / yyyy format.

# Alternative - our format - dd / mm / yyyy
strDates <- c("05/01/1965", "16/08/1975")
dates <- as.Date(strDates, "%d/%m/%Y")
dates

myformat <- "%m/%d/%y"
leadership$testDate <- as.Date(leadership$testDate, myformat)
leadership

# useful functions
Sys.Date()

date()

# use the format(x, format="output_format") function to output dates 
# in a specified format and to extract portions of dates
today <- Sys.Date()
format(today, format = "%d %B %Y")
format(today, format = "%A")

# dates stored locally as no of days since 1/1/1970 and negative
# values for earlier dates
startdate <- as.Date("2005-03-01")
enddate <- as.Date("2005-04-01")
days <- enddate - startdate
days

# the function difftime() calculates a time interval 
# and express it as seconds, minutes, hours, days, or weeks
# How old am I in weeks?
today <- Sys.Date()
dob <- as.Date("1977-03-08")
difftime(today, dob, units = "weeks")

# Type conversions -------------------------------------------------
a <- c(1, 2, 3)
a
is.numeric(a)
is.vector(a)
# convert the numeric vector to a character one
a <- as.character(a)
a
is.numeric(a)
is.vector(a)
is.character(a)

# Sorting data - using order() function
# By default, the sorting order is ascending. Pre-appending the 
# sorting variable with a minus sign indicates descending order. 

# Eg sort leadership dataset on age
newdata <- leadership[order(leadership$age),]
leadership # original
newdata # new sorted dataset

# sorts the rows by gender, and then from oldest to youngest manager within each gender
newdata <- leadership[order(gender, - age),]
newdata

# Merge datasets - see notes

#Selecting variables to keep in a dataset (Inclusion) ----------------------------------
leadership # view structure to see what we want to extract
newdata <- leadership[, c(6:10)]
newdata

#Same as this - variable names (in quotes) are entered as column indices
myvars <- c("q1", "q2", "q3", "q4", "q5")
newdata <- leadership[myvars]
newdata

#Also - paste() function to create the same character vector as in the previous example
# Paste covered soon
myvars <- paste("q", 1:5, sep = "")
newdata <- leadership[myvars]

# Excluding (dropping) variables ---------------------------------------------------------
# Eg if a variable has many missing values, you may want to drop it prior to further analyses
names(leadership) # character vector of names

# Logical vector - TRUE when element in names matches q3 or q4
names(leadership) %in% c("q3", "q4")
# We can use this 
myvars <- names(leadership) %in% c("q3", "q4")
myvars

# ! operator reverses the logical values - excludes where the match is TRUE - removes q3 and q4
newdata <- leadership[!myvars]
newdata
# Pre-append column index with a minus sign (-) excludes that column
newdata <- leadership[c(-8, -9)]
newdata

# set columns q3 and q4 to undefined (NULL).  Not the same as NA
leadership$q3 <- leadership$q4 <- NULL
leadership

# Selecting observations --------------------------------------------------------------------
newdata <- leadership[1:3,]
newdata <- leadership[leadership$gender == "M" & leadership$age > 30,]
newdata

# Alternatively
attach(leadership)
newdata <- leadership[gender == 'M' & age > 30,]
detach(leadership)
newdata

# records within specific date range
# First we need to create a variable to hold the structure of the date fields
leadership
leadership$testDate <- as.Date(leadership$testDate, "%m/%d/%y")
# Then we set the start and end dates of what we’re going to search for
startdate <- as.Date("2009-01-01")
enddate <- as.Date("2009-10-31")

# Then we find the data we require
newdata <- leadership[which(leadership$testDate >= startdate &
                      leadership$testDate <= enddate),]
newdata

# We needed to set the structure of testDate as we cahanged it earlier

# Subset function
# Much easier to use than the last set of commands

newdata <- subset(leadership, age >= 35 | age < 24,
                  select = c(q1, q2, q5))
newdata

newdata <- subset(leadership, gender == "M" & age > 25,
                  select = gender:q2)
newdata

# Random samples - see document for more details
help(sample)
# In this example, sample is within range 1 to no of rows in data set
mysample <- leadership[sample(1:nrow(leadership), 3, replace = FALSE),]
mysample

# From 3 to end of sample
mysample <- leadership[sample(3:nrow(leadership), 3, replace = FALSE),]
mysample

# SQL statement --------------------------------------------------------
# using the mtcars dataset
mtcars

install.packages("sqldf")
library(sqldf)
newdf <- sqldf("select * from mtcars where carb=1 order by mpg",
row.names = TRUE)
newdf

# This statement retrieves the mean mpg and displacement (disp) 
# within each level of gear for cars with four or six cylinders (cyl)
sqldf("select avg(mpg) as avg_mpg, avg(disp) as avg_disp, gear
       from mtcars where cyl in (4, 6) group by gear")
