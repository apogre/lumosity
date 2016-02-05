getwd()
setwd("C:/Users/apradha7/Downloads/Project_2016/lumosity")

f="Dump012_7028.txt"
myfile = paste("ONR2_Emotiv/",f,sep="")
data = read.csv(file=myfile, header=TRUE, fill=TRUE,skip = 4, sep = "\t")
