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
dataPlot$datetime <- strptime(paste(dataPlot$Date, dataPlot$Time), format = "%d/%m/%Y %H:%M:%S")

# Plot2
plot(y=dataPlot$Global_active_power, x=dataPlot$datetime, ylab = "Global Active Power(kilowatts)", xlab = "", type = "l")
dev.copy(png, "plot2.png")
dev.off()