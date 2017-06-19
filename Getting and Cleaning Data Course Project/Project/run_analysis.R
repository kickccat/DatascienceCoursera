# Create the project folder, if it does not exist
if(!file.exists("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera/Project")){
    dir.create(file.path("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera", "Project"))
}

# Set the folder as the workspace
setwd(file.path("C:/Users/yi.zhou/Workspace/DataScience/R/Coursera", "Project"))

# Download the datasets and unzip
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile =  "Dataset.zip")
unzip(zipfile = "Dataset.zip", exdir = "Datasets")

# 1.Merges the training and the test sets to create one data set.
## Read the activity data
xTrain <- read.table("./Datasets/UCI HAR Dataset/train/X_train.txt")
xTest <- read.table("./Datasets/UCI HAR Dataset/test/X_test.txt")

## Read the label data
yTrain <- read.table("./Datasets/UCI HAR Dataset/train/y_train.txt")
yTest <- read.table("./Datasets/UCI HAR Dataset/test/y_test.txt")

## Read the subject data
subjectTrain <- read.table("./Datasets/UCI HAR Dataset/train/subject_train.txt")
subjectTest <- read.table("./Datasets/UCI HAR Dataset/test/subject_test.txt")

## Read the features
features <- read.table("./Datasets/UCI HAR Dataset/features.txt")

## Assign the column names
colnames(subjectTrain) <- "subjectID"
colnames(subjectTest) <- "subjectID"
colnames(yTrain) <- "activityID"
colnames(yTest) <- "activityID"
colnames(xTrain) <- features[, 2]
colnames(xTest) <- features[, 2]

## Merge all data in one set
mergedTrain <- cbind(subjectTrain, yTrain, xTrain)
mergedTest <- cbind(subjectTest, yTest, xTest)
mergedAll <- rbind(mergedTrain, mergedTest)

# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
## Select the wanted features
colNames <- colnames(mergedAll)
featuresRequired <- (grepl("subjectID", colNames) | grepl("activityID", colNames) | grepl("-mean..", colNames) | grepl("-std..", colNames)) & (!grepl("-meanFreq..", colNames))

## Extract the mean and standard deviation measurement
measurementMeanAndStd <- mergedAll[, featuresRequired == TRUE]

# 3.Uses descriptive activity names to name the activities in the data set
## Read the activity labels
activityLabels <- read.table("./Datasets/UCI HAR Dataset/activity_labels.txt", col.names = c("activityID", "activityDiscription"))
## Set the descriptive activity names
measurementMeanAndStd$activityID <- factor(measurementMeanAndStd$activityID, labels = activityLabels$activityDiscription)

# 4.Appropriately labels the data set with descriptive variable names.
colNames <- names(measurementMeanAndStd)
colNames <- gsub("activityID", "activity", colNames)
colNames <- gsub("^t", "time", colNames)
colNames <- gsub("^f", "freq", colNames)
colNames <- gsub("\\()", "", colNames)
colNames <- gsub("Acc", "Accelerometer", colNames)
colNames <- gsub("Gyro", "Gyroscope", colNames)
colNames <- gsub("Mag", "Magnitude", colNames)
colNames <- gsub("BodyBody", "Body", colNames)
colnames(measurementMeanAndStd) <- colNames

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
## Import the dplyr package
library(dplyr)
secondDataset <- tbl_df(measurementMeanAndStd)

## Summarise the dataset groupby each activity and subject
secondDataset <- secondDataset %>%
    group_by(subjectID, activity) %>%
    summarise_each(funs(mean)) %>%
    print

## Save the independent tidy data
write.table(secondDataset, file = "tidyDataset.txt", row.names = FALSE)
