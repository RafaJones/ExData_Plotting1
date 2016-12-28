# READING THE DATA 

setwd("C:/Users/Rafa Jones/Documents/") #set directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

download.file(fileUrl, destfile = "./data/electric")
unzip("./data/electric")
#unzip the data  

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


#plot2 is a lined plot of Global Active Power
png(filename = "plot2.png",width = 480, height = 480, units = "px")

with(electricfeb, plot(Global_active_power, type = "l",
                       xlab = "", ylab = "Global Active Power (kilowatts)",
                       xaxt = 'n'))  #plots with a line, removes x axis label & markings

axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat"))
#positions correct markings Thurs, Fri, Sat. 


dev.off()
