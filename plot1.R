#READING THE DATA 

setwd("C:/Users/Rafa Jones/Documents/") #set directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileUrl, destfile = "./data/electric")
unzip("./data/electric")
#this will list the file including its size, length, etc 

columnnames <- c("Date","Time","Global_active_power","Global_reactive_power",
                 "Voltage","Global_intensity","sub_metering_1","sub_metering_2","sub_metering_3")

#reads the entire file, skips column row and adds columnnames manually 
electricdata <- read.table("household_power_consumption.txt", col.names = columnnames,
                           na.strings = "?", sep = ";", skip = 1, stringsAsFactors = FALSE) 


library(dplyr)
library(lubridate)

electricfeb <- subset(electricdata, Date == "1/2/2007" | Date == "2/2/2007") #subset dates
electricfeb$Date <- as.Date(parse_date_time(electricfeb$Date, "dmy")) #format as Date
electricfeb <- tbl_df(electricfeb) #dplyr table
electricfeb <- group_by(electricfeb, Date) #group by for plotting

#this is the data set used for plotting 


#Plot 1 is a histogram of Global Active Power, colored red, with a clean title and xlab
png(filename = "plot1.png",width = 480, height = 480, units = "px")

with(electricfeb, hist(Global_active_power, col = "red", main = "Global Active Power",
                    xlab = "Global Active Power (kilowatts)"))

dev.off()
