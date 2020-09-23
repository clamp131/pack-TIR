library(ggplot2)
PIX50000<-read.table("X-50000.pi")   
names(PIX50000)<-c("pos","pi","group")
PX50K<-ggplot(PIX50000,aes(pos,pi,group=group,colour=group))+geom_point()+geom_line()+geom_vline(xintercept=2639224,colour="lightblue")+labs(x="POS(X:2639224)",title="X:2639224-50K") 