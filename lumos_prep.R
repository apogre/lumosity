install.packages("plyr")
install.packages("zoo")
library(plyr)
library(zoo)
getwd()
setwd("C:/Users/apradha7/Downloads/Project_2016/lumosity")

f="Dump038_7052.txt"
myfile = paste("ONR2_Emotiv/",f,sep="")
data = read.csv(file=myfile, header=TRUE, fill=TRUE,skip = 4, sep = "\t")

ex_data <- data[,c("StimulusName","EventSource","Timestamp","Engagement","ExcitementLongTerm","ExcitementShortTerm","Frustration","Meditation")]
f_data <- ex_data[grep("EmotivAffectiv", ex_data$EventSource),]
summary(f_data$StimulusName)
df <- f_data[f_data$StimulusName=="Lumos",]
df$Timestamp= strptime(x = sub(pattern = '([0-9]{8})_([0-9]{2})([0-9]{2})([0-9]{2})([0-9]*)',
                               replacement = '\\1 \\2:\\3:\\4.\\5',x =df$Timestamp),format = '%Y%m%d %H:%M:%OS')

df$time <- as.factor(format(df$Timestamp,'%H:%M:%OS'))
df$Timestamp <- NULL
tdf<-ddply(df,.(time),summarise, Engagement = mean(Engagement), ExcitementLongTerm = mean(ExcitementLongTerm),
           ExcitementShortTerm=mean(ExcitementShortTerm), Frustration=mean(Frustration),Meditation=mean(Meditation))

summary(tdf)

tdf$Engagement[tdf$Engagement < 0]<-NA
tdf$Meditation[tdf$Meditation < 0]<-NA

tdf$ExcitementLongTerm[tdf$ExcitementLongTerm < 0]<-NA
tdf$ExcitementShortTerm[tdf$ExcitementShortTerm < 0]<-NA

summary(tdf)
tdf$Engagement<-na.approx(tdf$Engagement, na.rm = FALSE)
tdf$Meditation<-na.approx(tdf$Meditation, na.rm = FALSE)
tdf$ExcitementLongTerm<-na.approx(tdf$ExcitementLongTerm, na.rm = FALSE)
tdf$ExcitementShortTerm<-na.approx(tdf$ExcitementShortTerm, na.rm = FALSE)

summary(tdf)
write.table(tdf, file=f,row.names = FALSE,sep = "," ,col.names=TRUE, quote= FALSE)
tdf1 = read.csv(file=f, header=TRUE, fill=TRUE,skip = 0, sep = "\t")
summary(tdf1)
tdf1$Meditation[tdf1$Meditation == 0]<-NA
tdf1$Meditation<-na.approx(tdf1$Meditation, na.rm = FALSE)
tdf1$Engagement[tdf1$Engagement == 0]<-NA
tdf1$Engagement<-na.approx(tdf1$Engagement, na.rm = FALSE)

summary(tdf1)
write.table(tdf1, file="P37.txt",row.names = FALSE,sep = "," ,col.names=TRUE, quote= FALSE)

check = read.csv(file="processed_Emotiv/P11_1.txt", header=TRUE, fill=TRUE,skip = 0, sep = ",")
summary(check)
tdf1<-check

tdf1$Meditation[tdf1$Meditation<0.05]<-NA        
