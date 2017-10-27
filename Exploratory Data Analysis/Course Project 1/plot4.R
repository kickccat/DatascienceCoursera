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

# Plot4
png("plot4.png", width = 480, height = 480)
par(mar=c(4, 4, 2, 2), mfrow=c(2, 2))
plot(y=dataPlot$Global_active_power, x=dataPlot$datetime, ylab = "Global Active Power", xlab = "", type = "l")
plot(y=dataPlot$Voltage, x=dataPlot$datetime, ylab = "Voltage", xlab = "datetime", type = "l")
plot(y=dataPlot$Sub_metering_1, x=dataPlot$datetime, ylab = "Energy sub metering", xlab = "", type = "l")
lines(y=dataPlot$Sub_metering_2, x=dataPlot$datetime, col="red")
lines(y=dataPlot$Sub_metering_3, x=dataPlot$datetime, col="blue")
legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), lty = c(1, 1, 1), lwd = c(2, 2, 2), bty = "n", cex = 1, y.intersp = 1, xjust = 0.5)
plot(y=dataPlot$Global_reactive_power, x=dataPlot$datetime, ylab = "Global_reactive_power", xlab = "datetime", type = "l")
dev.off()