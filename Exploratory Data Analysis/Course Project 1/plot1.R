# Set the current folder where the R-file exists as the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Create the data folder, if it does not exist
if(!file.exists("./Datasets")){
    # Download the datasets and unzip
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, destfile =  "Dataset.zip")
    unzip(zipfile = "Dataset.zip", exdir = "Datasets")
    
    # Remove the zip file
    file.remove("Dataset.zip")
}

# Read the file and set the "NA" value as "?"
datasets <- read.csv("./Datasets/household_power_consumption.txt", header = TRUE, sep = ";", na.strings = "?", nrows = 2075259)
dataPlot <- subset(datasets, Date %in% c("1/2/2007", "2/2/2007"))

# Plot1
hist(dataPlot$Global_active_power, main = "Global Active Power", xlab = "Global Active Power(kilowatts)", ylab = "Frequency", col = "red", axes = TRUE)
dev.copy(png, "plot1.png")
dev.off()