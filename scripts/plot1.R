require(ggplot2);
data<-read.csv(file = "D:\\nosql-egzam\\nosql-exam\\results\\result1.csv", header=TRUE)
ggplot( data = data, aes(age,count,group = 1 )) + geom_bar(stat="identity") + 
   xlab("przedzia³ wiekowy") + ylab("liczba samobójstw")