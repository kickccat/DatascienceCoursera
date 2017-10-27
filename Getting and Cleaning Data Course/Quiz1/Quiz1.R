setwd("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera/Quiz1")

# Data 1
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 
# and load the data into R. The code book, describing the variable names is here:     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 
# How many properties are worth $1,000,000 or more?
myFile <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv", "data1.csv")
list.files()
dateDownload <- date()
mydf <- read.csv("data1.csv", header = TRUE)

library(data.table)
mytb <- data.table(mydf)
mytb[, .N, by=VAL==24] ## solution1 53
mytb[VAL==24, .N] ## solution2 53

# Use the data you loaded from Question 1. Consider the variable FES in the code book. Which of the "tidy data" principles does this variable violate?
table(mydf$FES)

# Data 2
# Download the Excel spreadsheet on Natural Gas Aquisition Program here:     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx 
# Read rows 18-23 and columns 7-15 into R and assign the result to a variable called: 
# dat
#
# What is the value of:
# sum(dat$Zip*dat$Ext,na.rm=T)
# (original data source: http://catalog.data.gov/dataset/natural-gas-acquisition-program)
library(xlsx)
excelFile <- download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx", "data2.xlsx", mode = "wb")

dateDownload2 <- date()
rowsIndex <- 18:23
colsIndex <- 7:15
dat <- read.xlsx("data2.xlsx", sheetIndex = 1, rowIndex = rowsIndex, colIndex = colsIndex)
sum(dat$Zip*dat$Ext,na.rm=T) # 36534720

# Data 3
# Read the XML data on Baltimore restaurants from here:     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml 
# How many restaurants have zipcode 21231?
library(RCurl)
library(XML)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
xmlData <- getURL(fileUrl)
doc <- xmlParse(xmlData)
rootNode <- xmlRoot(doc)
xmlName(rootNode) # Show name
zipcode <- xpathSApply(rootNode, "//zipcode", xmlValue)
sum(zipcode=="21231") # 127

# Data 4
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv 
# using the fread() command load the data into an R object:
# DT
#
# The following are ways to calculate the average value of the variable:
# pwgtp15
# broken down by sex. Using the data.table package, which will deliver the fastest user time?
DT <- data.table::fread("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv")
library(microbenchmark)
mbm <- microbenchmark(s1=DT[,mean(pwgtp15),by=SEX], s2=sapply(split(DT$pwgtp15,DT$SEX),mean), s3=mean(DT$pwgtp15,by=DT$SEX), s4=tapply(DT$pwgtp15,DT$SEX,mean), mean(DT[DT$SEX==1,]$pwgtp15), mean(DT[DT$SEX==2,]$pwgtp15), times = 100L)


system.time(mean(DT[DT$SE == 1, ]$pwgtp15) + DT[DT$SEX == 2, ]$pwgtp15)
system.time(DT[, mean(pwgtp15), by = SEX])
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
system.time(mean(DT$pwgtp15, by = DT$SEX))
system.time(rowMeans(DT)[DT$SEX==1] + rowMeans(DT)[DT$SEX==2])
system.time(tapply(DT$pwgtp15, DT$SEX, mean))