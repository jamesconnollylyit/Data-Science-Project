# Keyboard input
# edit() function in R invokes a text editor 
# Eg
# Assignments such as age=numeric(0) create a variable of a specific mode, but without data
mydata <- data.frame(age = numeric(0), gender = character(0), weight = numeric(0))
# The result of the editing is assigned back to the object. no object = lost data
mydata <- edit(mydata)
mydata
summary(mydata)
# Shortcut - fix(mydata)
fix(mydata)

# Alternatively we can embed the data directly in a program
mydatatxt <- "
age gender weight
31 f 133
22 f 135
34 m 165
"
# The read.table() function is used to process the string and return a data frame 
mydata <- read.table(header = TRUE, text = mydatatxt)
mydata
summary(mydata)
fix(mydata)

# Import from a delimited text file ------------------------------------------------
# Syntax  .... mydataframe <- read.table(file, options)
# Where file is a delimited ASCII file and the 
# options are parameters controlling how data is processed

#EG

grades
# Look at structure
str(grades)
# See notes on changes
# By default, read.table() converts character variables to factors - not always wanted
# Use stringsAsFactors=FALSE to turn off or 
# colClasses option to specify a class (for example, logical, numeric, character, or factor) for each column
#Eg

grades <- read.table("studentgrades.csv", header = TRUE,
                    row.names = "StudentID", sep = ",",
                    colClasses = c("character", "character", "character",
                    "numeric", "numeric", "numeric"))
# row names now contain their leading zeros
grades
#structure
str(grades)

#We can also read files from other locations, URL - ftp, http, proxy
# See help(file)

# Import from Excel ----------------------------------------------------------
install.packages("xlsx")
install.packages("rJava")
# All packages in local library
installed.packages()
# Chcek if the package exists
find.package("xlsx")
find.package("rJava")

# read.xlsx(file, n) where file is the path to an Excel workbook
# n is the number of the worksheet to be imported, and the first line 
# of the worksheet contains the variable names

#Eg
library(xlsx)
workbook <- "d:/grades.xlsx"
mydataframe <- read.xlsx(workbook, 1)
mydataframe

# large worksheets (100,000+ cells), use read.xlsx2(). 
# It performs more of the processing work in Java, resulting in significant performance gains. 
# See help(read.xlsx) for details

# Web scraping ----------------------------------------------------------------
# Install the RCurl package if necessary
install.packages("RCurl", dependencies = TRUE)
library("RCurl")

# Install the XML package if necessary
install.packages("XML", dependencies = TRUE)
library("XML")

# Get first quarter archives
jan09 <- getURL("https://stat.ethz.ch/pipermail/r-help/2009-January/date.html", ssl.verifypeer = FALSE)

jan09_parsed <- htmlTreeParse(jan09)

#ODBC ----------------------------------------------------------------------------
install.packages("RODBC")
library(RODBC)
# Use the sqlserver ODBC connection
# with these credentials
ch <- odbcConnect("sqlserver", uid = "james", pwd = "Mypassword123")
sqlTables(ch) # which tables are available through this connection

# A table can be retrieved as a data frame by
res <- sqlFetch(ch, "customer")
res # show table contents
res <- sqlFetch(ch, "customer", max = 100) # only retrieve first 100 rows

# Use the ODBCconnection called adventure
ch <- odbcConnect("adventure", uid = "james", pwd = "Mypassword123")

# Show layout of Sales.Customer table 
sqlColumns(ch, "Sales.Customer")

# Run SQL query to extract all rows from Sales.Customer
customerdata <- sqlQuery(ch, "select * from Sales.Customer")
# Show first 6 rows
head(customerdata)

# Send this JOIN query on the adventureworks tables accessed through the ODBC connector above
# Returns output to screen
sqlQuery(ch, paste("SELECT Person.BusinessEntity.*, JobTitle
                    FROM Person.BusinessEntity
                    INNER JOIN HumanResources.Employee
                    ON Person.BusinessEntity.BusinessEntityID =
                    HumanResources.Employee.BusinessEntityID
                  "))

# Run this query and retrun results to a data frame
customerdata <- sqlQuery(ch, "SELECT CustomerID, SalesPersonID, COUNT(*)
                            FROM Sales.SalesOrderHeader
                            WHERE CustomerID <= 11010
                            GROUP BY CustomerID, SalesPersonID
                            ORDER BY CustomerID, SalesPersonID;
                   ")

head(customerdata)
str(customerdata)
