library(dplyr)
setwd("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera")

# Create the new folder if not exists and set as the workspace 
dir.create(file.path("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera", "Quiz4"))
setwd(file.path("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera", "Quiz4"))

# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?

# Download the file from URL and read it as dataframe
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
myFileLocation <- download.file(fileURL, "data1.csv")
mydf <- read.csv("data1.csv")

mytb <- tbl_df(mydf)
rm("mydf") # Release the in memory saved dataframe

colNamesSplit <- strsplit(names(mytb), "wgtp")
colNamesSplit[[123]] # ""   "15"

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
# 
# Original data sources:
#     
#     http://data.worldbank.org/data-catalog/GDP-ranking-table
fileURL2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
# Select the special columns for using mode "wb"
myFileLocation2 <- download.file(fileURL2, "data2.csv", mode = "wb")
mydf2 <- data.table::fread("data2.csv", skip = 5, select = c(1, 2, 4, 5), col.names = c("CountryCode", "Ranking", "Country", "GDP"), nrows = 190)

mytb2 <- tbl_df(mydf2)
rm("mydf2")
mytb2 %>% mutate(GDP = as.integer(gsub(",", "", GDP))) %>% summarize(mean(GDP)) %>% print # 377652.4

# In the data set from Question 2 what is a regular expression that would allow you to count the number of countries whose name begins with "United"? Assume that the variable with the country names in it is named countryNames. How many countries begin with United?
grep("^United", mytb2$Country) # 1  6 32
mytb2[grep("^United", mytb2$Country), ] # A tibble: 3 × 4
# CountryCode Ranking              Country      GDP
# <chr>       <int>                <chr>       <chr>
# 1         USA       1        United States  16,244,600 
# 2         GBR       6       United Kingdom   2,471,784 
# 3         ARE      32 United Arab Emirates     348,595 

# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June?
# 
# Original data sources:
#     
#     http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats
fileURL3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
myFileLocation3 <- download.file(fileURL3, "data3.csv", mode = "wb")
mydf3 <- read.csv("data3.csv")
mytb3 <- tbl_df(mydf3)
rm("mydf3")

matchedTB <- tbl_df(merge(mytb2, mytb3, by = "CountryCode"))
summarize(matchedTB[grep("Fiscal year end: June", matchedTB$Special.Notes), ], n()) # A tibble: 1 × 1
# `n()`
# <int>
#1 13

# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times the data was sampled.
# How many values were collected in 2012? How many values were collected on Mondays in 2012?
library(lubridate)
# Read data from quantmod library
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

sampleTimes <- ymd(sampleTimes)
year2012 <- grep("^2012", sampleTimes)
length(year2012)# 250
sum(wday(sampleTimes[year2012])==2) # 47