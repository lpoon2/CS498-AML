library(klaR)
library(caret)
wdat = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data", header=FALSE)
bigx<-wdat[,-c(9)]
bigy<-as.factor(wdat[,9])
wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)
svm<-svmlight(bigx[wtd,], bigy[wtd], pathsvm='/Library/Frameworks/R.framework/Resources/library/svmlight')
labels<-predict(svm, bigx[-wtd,])
foo<-labels$class
sum(foo==bigy[-wtd])/(sum(foo==bigy[-wtd])+sum(!(foo==bigy[-wtd])))