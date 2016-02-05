install.packages("plyr")
library(plyr)
getwd()
setwd("C:/Users/apradha7/Downloads/Project_2016/lumosity")

f="Dump012_7028.txt"
myfile = paste("ONR2_Emotiv/",f,sep="")
data = read.csv(file=myfile, header=TRUE, fill=TRUE,skip = 4, sep = "\t")

ex_data <- data[,c("StimulusName","EventSource","Timestamp","Engagement","ExcitementLongTerm","ExcitementShortTerm","Frustration","Meditation")]
f_data <- ex_data[grep("EmotivAffectiv", ex_data$EventSource),]
df <- f_data[f_data$StimulusName=="Lumos",]
df$Timestamp= strptime(x = sub(pattern = '([0-9]{8})_([0-9]{2})([0-9]{2})([0-9]{2})([0-9]*)',
                               replacement = '\\1 \\2:\\3:\\4.\\5',x =df$Timestamp),format = '%Y%m%d %H:%M:%OS')

df$time <- as.factor(format(df$Timestamp,'%H:%M:%OS'))
df$Timestamp <- NULL
tdf<-ddply(df,.(time),summarise, Engagement = mean(Engagement), ExcitementLongTerm = mean(ExcitementLongTerm),
           ExcitementShortTerm=mean(ExcitementShortTerm), Frustration=mean(Frustration),Meditation=mean(Meditation))
