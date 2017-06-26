# Getting and Cleaning Data Course Project

## Purpose
This project will demonstrate to collect and clean a data set, that will be used for the subsequent analysis. The process will be required to submit:
1. a tidy data set as described below;
2. a link to a Github repository with your script for performing the analysis;
3. a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md;
4. a README.md in the repo with your scripts;
5. an R script called run_analysis.R

## Data source
The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:\
[Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).\
Here are the data used for the project:\
[Source data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip).

## Summary
* R script ["run_analysis.R"](https://github.com/kickccat/DatascienceCoursera/blob/master/Getting%20and%20Cleaning%20Data%20Course/Project/run_analysis.R) does the following:
  + Merges the training and the test sets to create one data set.
  + Extracts only the measurements on the mean and standard deviation for each measurement.
  + Uses descriptive activity names to name the activities in the data set.
  + Appropriately labels the data set with descriptive variable names.
  + From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  
* The tidy data set file ["tidyDataset.txt"](https://github.com/kickccat/DatascienceCoursera/blob/master/Getting%20and%20Cleaning%20Data%20Course%20Project/tidyDataset.txt) is from the last step of R-script process about the mean measurement of each activity and each subject.
