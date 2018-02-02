library(klaR)
library(caret)
data = read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data", header=FALSE)

#split data into features and labels
bigx<-data[,-c(9)]
bigy<-as.factor(data[,9])

wtd<-createDataPartition(y=bigy, p=.8, list=FALSE)

trax<-bigx[wtd,]
tray<-bigy[wtd]

#train data 10 times w/ cv
model<-train(trax, tray, 'nb', trControl=trainControl(method='cv', number=10))

#testig classifier 
teclasses<-predict(model,newdata=bigx[-wtd,])
m<-confusionMatrix(data=teclasses, bigy[-wtd])

#parse accuracy
acc = m$overall['Accuracy']
acc
