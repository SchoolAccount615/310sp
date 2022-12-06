install.packages("tidyverse")
library("tidyr")

## create our first data frame

df <- read.csv("624_runoff_chemistry.csv")

## take what we want from this dataframe: the pH and the date the sample was collected.

ph <- subset(df[c("ph", "runoff_datetime")], ph != c("FALSE", "TRUE", "NA"))

## split datetime object into 2 columns: date and time
ph2 <- ph %>% separate(col = runoff_datetime, into = c("date", "time"), 
                      sep = ' ', remove = TRUE, convert = TRUE)

## order the rows by date
ph2 <- ph2[order(as.Date(ph2$date, format = "%Y-%m-%d")),]

## remove outliers - filter out any runoff water allegedly
## more acidic than stomach acid or more basic than milk
## of magnesia
ph2 <- filter(ph2, ph < 11 & ph > 1)

## sets date column to type 'date'
ph2$date <- as.Date(ph2$date)

## creates plot
 ggplot(data = ph2) + 
  geom_point(mapping = aes(x = date, y = ph)) + geom_smooth(method=lm, aes(date, ph))

