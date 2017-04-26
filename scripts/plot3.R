require(ggplot2)
require(scales)
data<-read.csv(file = "D:\\nosql-egzam\\nosql-exam\\results\\result2_m.csv", header=TRUE,sep=';')
data_m <- data
data_m$count_f <- NULL
names(data_m)[names(data_m) == "count_m"] <- "count"

data_f <- data
data_f$count_m <- NULL
names(data_f)[names(data_f) == "count_f"] <- "count"

data_m$name <- "male"
data_f$name <- "female"
d <- rbind(data_m,data_f)
p <- ggplot(d, aes(status,count, fill = name)) + geom_bar(stat="identity",position = "dodge")
f<-p+theme(axis.text.x = element_text(angle = 90, hjust = 1))+ scale_y_continuous(name="liczba zgonów", labels = comma)+
  xlab("stan cywilny")
f