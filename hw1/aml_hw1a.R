data = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data", header=FALSE)
library(klaR)
library(caret)
bigx<-data[,-c(9)]
bigy<-data[,9]

trscore<-array(dim=10)
tescore<-array(dim=10)
for (wi in 1:10)
{
#parition  
wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
#all data with attrs
nbx<-bigx

#training data
ntrbx<-nbx[wtd, ]
ntrby<-bigy[wtd]

#filter for label 1 items
trposflag<-ntrby>0

ptregs<-ntrbx[trposflag, ] #positive training items
ntregs<-ntrbx[!trposflag,] #negative training items

#testing data
ntebx<-nbx[-wtd, ]
nteby<-bigy[-wtd]

trposflag<-nteby>0
ptesegs<-ntebx[trposflag, ] #positive training items
ntesegs<-ntebx[!trposflag,] #negative training items

#pos and neg means
ptrmean<-sapply(ptregs, mean, na.rm=TRUE)
ntrmean<-sapply(ntregs, mean, na.rm=TRUE)

#pos and neg std
ptrsd<-sapply(ptregs, sd, na.rm=TRUE)
ntrsd<-sapply(ntregs, sd, na.rm=TRUE)

#normalize pos data
ptroffsets<-t(t(ntrbx)-ptrmean)
ptrscales<-t(t(ptroffsets)/ptrsd)

#model for log(p(y))
ptr<-dim(ptregs)[1]/(dim(ptregs)[1]+dim(ntregs)[1])

ptrlogs<--(1/2)*rowSums(apply(ptrscales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ptrsd)) + log(ptr)

#normalize neg data
ntroffsets<-t(t(ntrbx)-ntrmean)
ntrscales<-t(t(ntroffsets)/ntrsd)
ntr<-dim(ntregs)[1]/(dim(ptregs)[1]+dim(ntregs)[1])
ntrlogs<--(1/2)*rowSums(apply(ntrscales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ntrsd)) + log(ntr)

#get training score 
lvwtr<-ptrlogs>ntrlogs
gotrighttr<-lvwtr==ntrby
trscore[wi]<-sum(gotrighttr)/(sum(gotrighttr)+sum(!gotrighttr))

pteoffsets<-t(t(ntebx)-ptrmean)
ptescales<-t(t(pteoffsets)/ptrsd)
ptes<-dim(ptesegs)[1]/(dim(ptesegs)[1]+dim(ntesegs)[1])
ptelogs<--(1/2)*rowSums(apply(ptescales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ptrsd)) + log(ptes)

nteoffsets<-t(t(ntebx)-ntrmean)
ntescales<-t(t(nteoffsets)/ntrsd)
ntes<-dim(ntesegs)[1]/(dim(ptesegs)[1]+dim(ntesegs)[1])
ntelogs<--(1/2)*rowSums(apply(ntescales,c(1, 2), function(x)x^2), na.rm=TRUE)-sum(log(ntrsd))+ log(ntes)
#get test data score
lvwte<-ptelogs>ntelogs
gotright<-lvwte==nteby
tescore[wi]<-sum(gotright)/(sum(gotright)+sum(!gotright))
}
mean(tescore)
