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

png(filename = "plot4.png",width = 480, height = 480, units = "px")

par(mfcol = c(2,2), mar = c(4,4,1,4)) #column fill 4 plots in a 2 x 2 shape 
#margins adjusted to fit all y labels, xlabels (plots 3 & 4), and axes. 

#fills plot 2, plot 3 columnwise 

#plot 2
with(electricfeb, plot(Global_active_power, type = "l",
                       xlab = "", ylab = "Global Active Power",
                       xaxt = 'n'))  #plots with a line, removes x axis label & markings

axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat"))
#positions correct markings Thurs, Fri, Sat. 

#plot 3 
with(electricfeb, 
     plot(sub_metering_1, type = "l", col = "black", ylab = "Energy sub metering",
          xlab = "", xaxt = 'n'))  #plots submeter 1 as base, with y labeled, but NO X AXIS

points(electricfeb$sub_metering_2, type = "l", col = "red") #adds meter 2 as points
points(electricfeb$sub_metering_3, type = "l", col = "blue")#adds meter 3 as points 

axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat")) #ADDS AN X AXIS 

legend("topright", legend = c("sub_metering_1","sub_metering_2","sub_metering_3"),
       col = c("black","red","blue"),
       lty = 1, bty = "n", cex = 0.6)  #creates a smaller legend with no outer box 

#new voltage plot 

with(electricfeb, plot(Voltage, xaxt = 'n', xlab = "datetime",
                  ylab = "Voltage", type = "l"))
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat")) #ADDS AN X AXIS 

#new global reactive power plot 

with(electricfeb, plot(Global_reactive_power, xaxt ='n', xlab = "datetime",
                       type ="l", ylim = c(0,0.5)))
axis(1, at = c(0,1440,2880), labels = c("Thu","Fri","Sat")) #ADDS AN X AXIS 

dev.off()
