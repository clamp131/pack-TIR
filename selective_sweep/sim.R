library(ggplot2)
sum_X_1000<-read.table(file="sum_X_1000",stringsAsFactors=FALSE)
ggplot(data=cbind(sum_X_1000,sum_X_1000[,3]-sum_X_1000[,4]),aes(x=sum_X_1000[,3]-sum_X_1000[,4]))+geom_histogram(position='identity',aes(y= ..density..),bins=30)+stat_density(geom='line',position='identity')+xlab("refPI-altPI")+geom_vline(aes(xintercept=0.00047), colour="#BB0000", linetype="dashed")+labs(title="X:2.7M 10Kleft refPi-altPi")
ggsave(file="X_10Kleft_normal_1000.pdf")