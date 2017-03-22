#vector examples - only one type in same vector (mode)
a <- c(1, 2, 5, 3, 6, -2, 4) #numeric
b <- c("one", "two", "three") #character
c <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE) #logical
a[c(2, 4)] #2nd and 4th elements in vector a

a <- c("k", "j", "h", "a", "c", "m")
a[3]

a[c(1, 3, 5)]
a[2:6] #sequence of numbers
a <- c(2:6)
a <- c(2, 3, 4, 5, 6) #same as above

#Matrix
#Syntax - do not execute
#nrow and ncol specify row and col dimensions
#dimnames contains optional row and column labels stored in character vectors
#byrow indicates whether the matrix should be filled in by row. The default is by column
#Can only contain 1 data type (mode)
myymatrix <- matrix(vector, nrow = number_of_rows, ncol = number_of_columns,
  byrow = logical_value, dimnames = list(
  char_vector_rownames, char_vector_colnames))
#Example
y <- matrix(1:20, nrow = 5, ncol = 4)
y
cells <- c(1, 26, 24, 68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
mymatrix <- matrix(cells, nrow = 2, ncol = 2, byrow = TRUE, dimnames = list(rnames, cnames))
mymatrix
#We can change the matrix so that it is filled by column instead using this syntax:
mymatrix <- matrix(cells, nrow = 2, ncol = 2, byrow = FALSE, dimnames = list(rnames, cnames))
mymatrix
#Identifying elements in matrix
x <- matrix(1:10, nrow = 2) #2 × 5 matrix is created containing the numbers 1 to 10, by column (default)
x
x[2,]
x[, 2]
x[1, 4]
x[1, c(4, 5)]

#Arrays
#Syntax - do not run
# where vector contains the data for the array, 
# dimensions is a numeric vector giving the maximal index for each dimension
# and dimnames is an optional list of dimension labels
#Single mode
myarray <- array(vector, dimensions, dimnames)
#Example
dim1 <- c("A1", "A2")
dim2 <- c("B1", "B2", "B3")
dim3 <- c("C1", "C2", "C3", "C4")
myarray <- array(1:24, c(2, 3, 4), dimnames = list(dim1, dim2, dim3))
myarray
myarray[1, 2, 3]

#Data frame
#Syntax - do not run
# where col1, col2, col3, and so on are column vectors of any type 
# (such as character, numeric, or logical)
# Names for each column can be provided with the names function
# Each col = 1 mode, different cols = different modes
mydata <- data.frame(col1, col2, col3, ...)
# Example - functions to store each column of the example table 
patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")

patientdata <- data.frame(patientID, age, diabetes, status)
patientdata
#Identifying elements of the data frame
patientdata[2, 4]
# We can also ask for several columns at a time:
patientdata[1:3]
# Specify column names. Note - use the c function to identify the required column as a string
patientdata[c("diabetes", "status")]
# $ notation - indicate a particular variable from a given data frame (patientdata in this case)
table(patientdata$diabetes, patientdata$status)

# Attach, detatch, with - do not need to refer to full data frame name
# E.g. Using mtcars dataset
help(mtcars)
# view statistical information on the mpg variable in the dataset
summary(mtcars$mpg)
# plot mpg on the x-axis and disp on the y-axis of a chart
plot(mtcars$mpg, mtcars$disp)
plot(mtcars$mpg, mtcars$wt)
# Can also be written as:
attach(mtcars)
summary(mpg)
plot(mpg, disp)
plot(mpg, wt)
detach(mtcars) # removes data frame from search path
#Errors - examples
mpg <- c(25, 36, 47)
attach(mtcars) # error - the original object (mpg above) takes precedence
plot(mpg, wt) # fails because mpg (above) has 3 elements and wt has 32 elements
# Use attach and detatch if unlikely to have multiple objects with same name

# Alternative - with
# statements within the {} brackets are evaluated 
# with reference to the mtcars data frame
with(mtcars, {
    print(summary(mpg))
    plot(mpg, disp)
    plot(mpg, wt)
})

# limitations
# This is ok
with(mtcars, {
    stats <- summary(mpg)
    stats
})
# Not so good...
with(mtcars, {
    nokeepstats <- summary(mpg)
    keepstats <<- summary(mpg)
})
nokeepstats # not accessible
keepstats # okay - global variable

# Case identifiers - similar to primary key. Use 'row.names' option
# patientID as the variable to use in labelling cases on various printouts and graphs
patientdata <- data.frame(patientID, age, diabetes,
                          status, row.names = patientID)
patientdata

# Factors ----------------------------------------------------------------------------
# Categorical (nominal), and ordered categorical (ordinal) variables are called factors
# Crucial in R because they determine how data is analysed and presented visually
# Factor stores the categorical values as a vector of integers in 
# the range [1… k] for each nominal

# Example - consider this vector
diabetes <- c("Type1", "Type2", "Type1", "Type1")
diabetes
# Factor -  stores this vector as (1, 2, 1, 1) and associates it as nominal type
# with 1 = Type1 and 2 = Type2 internally (the assignment is alphabetical).
# Eg
diabetes <- factor(diabetes)
diabetes

# For vectors representing ordinal variables, add the parameter ordered=TRUE to the factor()
# Any analyses performed on this vector will treat the variable as ordinal and 
# select the statistical methods appropriately
status <- c("Poor", "Improved", "Excellent", "Poor")
status
# encode the vector as (3, 2, 1, 3) and associate these values internally 
# as 1 = Excellent, 2 = Improved, and 3=Poor

status <- factor(status, ordered = TRUE)
status

# Sometimes alphabetical is insufficient
# Override by specifying a levels option
status <- c("Poor", "Improved", "Excellent", "Poor")
# Assigns the levels as 1 = Poor, 2 = Improved, 3 = Excellent
status <- factor(status, order = TRUE,
                 levels = c("Poor", "Improved", "Excellent"))
status

# Numeric variables coded as factors
# This converts variables to an unordered factor
# Note that the order of the labels must match the order of the levels
# Sex would be treated as categorical, the labels “Male” and “Female” 
# would appear in the output instead of 1 and 2
sex <- c(2, 1, 1, 1, 2)
gender <- factor(sex, levels = c(1, 2), labels = c("Male", "Female"))
gender

# Enter our table
patientID <- c(1, 2, 3, 4)
age <- c(25, 34, 28, 52)
diabetes <- c("Type1", "Type2", "Type1", "Type1")
status <- c("Poor", "Improved", "Excellent", "Poor")

# Store diabetes vector as a vector of integers using the factor statement
# Note - stored as an unordered factor
diabetes <- factor(diabetes)
# Stored internally as (1,2,1,1)
diabetes

# Store status vector as an ordered factor, as identified by the order keyword
status <- factor(status, order = TRUE)

# Combine all vector data into a data frame using this syntax
patientdata <- data.frame(patientID, age, diabetes, status)

# View structure of the patientdata data frame 
# diabetes is a factor and status is an ordered factor
str(patientdata)

# Summary info on patientdata
# min, max, mean, quartiles for the continuous variable age
# and frequency counts for the categorical variables diabetes and status
summary(patientdata)

#Lists --------------------------------------------------------------
# Syntax - do not run
mylist <- list(object1, object2, ...)
# Eg
g <- "My First List" #title of list
# numeric vector, matrix and character vector
h <- c(25, 26, 18, 39)
j <- matrix(1:10, nrow = 5)
k <- c("one", "two", "three")
# Save elements into list
mylist <- list(title = g, ages = h, j, k)
mylist
# Calling elements
mylist[2]
# Same as
mylist["ages"]
# Also
mylist$ages

# Could add a reference name to j

mylist <- list(title = g, ages = h, extrainfo = j, k)
mylist$extrainfo
mylist["extrainfo"]
