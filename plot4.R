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

#Plot 4
png(filename = "./plot4.png")

par(mfcol=c(2,2), mar=c(4,4,2,2))
plot(hpc$DateTime,hpc$Global_active_power,type="l",xlab="",ylab="Global Active Power (kilowatts)")

plot(hpc$DateTime,hpc$Sub_metering_1,type="n",xlab = " ", ylab = "Energy sub metering")
points(hpc$DateTime,hpc$Sub_metering_1,type="l")
points(hpc$DateTime,hpc$Sub_metering_2,type="l",col="red")
points(hpc$DateTime,hpc$Sub_metering_3,type="l",col="blue")
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       , lty = c(1,1,1), col = c("black","red","blue"))

plot(hpc$DateTime,hpc$Voltage,type="l",xlab="datetime",ylab="Voltage")

plot(hpc$DateTime,hpc$Global_reactive_power,type="l",xlab="datetime", ylab="Global_reactive_power")

dev.off()
setwd("../")