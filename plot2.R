library(sqldf)
library(dplyr)

#Directory creation, setting WD and unzipping the file
if (!dir.exists("./data")) {
    dir.create("./data")
}
setwd("./data")
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              destfile="hpc.zip")
unzip("hpc.zip",exdir=".")

#Reading the file within the range of 01/02/07~02/02/07
hpc <- read.csv2.sql(file="./household_power_consumption.txt",sql= "select * from file where Date in ('1/2/2007','2/2/2007')"
                     , na.strings = "?",colClasses = c())

#Pasting hpc$Date and hpc$Time
hpc <- mutate(hpc, DateTime = with(hpc, paste(Date, Time)))

#Formatting the dates
hpc$DateTime <- strptime(hpc$DateTime, format= "%d/%m/%Y %H:%M:%S",tz=" ")

#Plot 2
png(filename = "./plot2.png")

plot(hpc$DateTime,hpc$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)")

dev.off()
setwd("../")