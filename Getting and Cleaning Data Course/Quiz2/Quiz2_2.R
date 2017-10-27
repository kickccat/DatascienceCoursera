setwd("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera/Quiz2")

# The sqldf package allows for execution of SQL commands on R data frames. We will use the sqldf package to practice the queries we might send with the dbSendQuery command in RMySQL.
# 
# Download the American Community Survey data and load it into an R object called:
# acs
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv
# 
# Which of the following commands will select only the data for the probability weights pwgtp1 with ages less than 50?

library(sqldf)
library(httr)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
myFileLocation <- download.file(fileURL, "data1.csv")
acs <- data.table::fread("data1.csv")

sqldf("select pwgtp1 from acs where AGEP < 50")

# unique(acs$AGEP)
sqldf("select distinct AGEP from acs")

# How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page:     
#     http://biostat.jhsph.edu/~jleek/contact.html 
# (Hint: the nchar() function in R may be helpful)

htmlConnect <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(htmlConnect)
close(htmlConnect)
c(nchar(htmlCode[10]), nchar(htmlCode[20]), nchar(htmlCode[30]), nchar(htmlCode[100])) # 45 31  7 25

# Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for 
# Original source of the data:
# http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for 
# (Hint this is a fixed width file format)

fileLocation <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
sampleLines <- readLines(fileLocation, n=10)
width <- c(1, 9, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3, 5, 4, 1, 3)
columnNames <- c("Blank", "Week", "Blank", "SSTNino1+2", "Blank", "SSTANino1+2", "Blank", "SSTNino3", "Blank", "SSTANino3", "Blank", "SSTNino34", "Blank", "SSTANino34", "Blank", "SSTNino4", "Blank", "SSTANino4")
myDF <- read.fwf(fileLocation, header = FALSE, skip = 4, widths = width, col.names = columnNames)
sum(myDF[, 8]) # 32426.7