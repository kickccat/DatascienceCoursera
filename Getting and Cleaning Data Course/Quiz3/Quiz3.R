setwd("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera/Quiz3")

# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# 
# which(agricultureLogical)
# 
# What are the first 3 values that result?

library(dplyr)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
mydf <- read.csv(file = fileURL)
mytb <- tbl_df(mydf)
rm("mydf") # Delete the duplicate dataframe

quiz1 <- mytb
agricultureLogical = (quiz1$ACR==3 & quiz1$AGS==6)
head(which(agricultureLogical), 3) # 125 238 262


# Using the jpeg package read in the following picture of your instructor into R
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)
library(jpeg)
jpegURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(jpegURL, "jeff.jpg", mode = "wb")
picture <- jpeg::readJPEG("jeff.jpg", native = TRUE)
quantile(picture, probs = c(0.3, 0.8)) # 30%       80% 
                                       # -15259150 -10575416


# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?
# 
# Original data sources:
#     
#     http://data.worldbank.org/data-catalog/GDP-ranking-table
# 
# http://data.worldbank.org/data-catalog/ed-stats
gdpURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
eduURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
mydf1 <- read.csv(gdpURL, skip = 4, nrows = 191)[, c(1:2, 4:5)]
colnames(mydf1) <- c("CountryCode", "Ranking", "Economy", "Summe")
## Or
# library("data.table")
# 
# mydf1 <- data.table::fread('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv', skip=4, nrows = 190, select = c(1, 2, 4, 5), col.names=c("CountryCode", "Ranking", "Economy", "Summe"))
# 
# mydf2 <- data.table::fread('https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv')
mydf2 <- read.csv(eduURL)
gdp <- tbl_df(mydf1)
rm("mydf1")
edu <- tbl_df(mydf2)
rm("mydf2")
mergedDT <- merge(gdp, edu, by="CountryCode")
nrow(mergedDT) # 189
arrange(mergedDT, desc(Ranking))[13, "Economy"] # St. Kitts and Nevis

# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
HiOEDT <- mergedDT %>% select(Economy, Ranking, Income.Group) %>%
    filter(Income.Group == "High income: OECD") %>%
    print
mean(HiDT$Ranking) # 32.96667

HiNonDT <- mergedDT %>% select(Economy, Ranking, Income.Group) %>%
    filter(Income.Group == "High income: nonOECD") %>%
    print
mean(HiNonDT$Ranking) # 91.91304

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries
# 
# are Lower middle income but among the 38 nations with highest GDP?
divide <- quantile(mergedDT$Ranking, probs = seq(0, 1, 0.2), na.rm = TRUE)
mergedDT <- tbl_df(mergedDT)
groupedDT <- mergedDT %>%
    select(Ranking, Income.Group) %>%
    mutate(dividedRank=cut(mergedDT$Ranking, breaks = divide)) %>%
    group_by(dividedRank)
table(groupedDT$Income.Group, groupedDT$dividedRank)                    
#                       (1,38.6] (38.6,76.2] (76.2,114] (114,152] (152,190]
#                             0           0          0         0         0
# High income: nonOECD        4           5          8         4         2
# High income: OECD          17          10          1         1         0
# Low income                  0           1          9        16        11
# Lower middle income         5          13         11         9        16
# Upper middle income        11           9          8         8         9