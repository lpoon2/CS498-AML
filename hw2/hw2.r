#load data and install packages
df_hw2 <- read.csv("C:/Users/titus/Documents/CS498/hw2/adult.data", header = FALSE)
library(klaR)
library(caret)
x <-df_hw2[c(1,3,5,11,12,13)] # continuous  data
y <- df_hw2[,15]

#get y as -1 or 1
y <- as.numeric(as.factor(y))
y[y == 1] <- -1
y[y == 2] <- 1

#split train, validation, and test set
split_train <- createDataPartition(y=y, p=.8, list=FALSE)
x_train <- x[split_train,]
y_train <- y[split_train]
x_temp <- x[-split_train,]
y_temp <- y[-split_train]
split_val_test <- createDataPartition(y=y_temp, p=.5, list=FALSE)
x_val <- x_temp[split_val_test,]
y_val <- y_temp[split_val_test]
x_test <- x_temp[-split_val_test,]
y_test <- y_temp[-split_val_test]


alpha<-matrix(data=0, ncol=NCOL(x_train))
beta<-0
lambda <- 0.01 #for now just use lambad as .01
for (epochs in 1:50) {
	steplen <- 1/(.01*epochs+50) #steplength
	for (steps in 1:300 ) 
		gamma<- (sum( t(alpha)  as.numeric(x_train[epochs*steps,]) + beta))

#using the equation in the book page 35
	if (gamma *  y_train[epochs*steps] > 1 ) {
		alpha <- alpha-(lambda * alpha * steplen )
	}
	else {
		alpha <- alpha-(lambda * alpha * steplen - y_train[epochs*steps] * x_train[epochs*steps,])
		beta  <- beta-(-(y_train[epochs*steps] ) * steplen)
	}
}

#test on testset
got_right <- 0
got_wrong <- 0
for (i in 1: 3000){
		gamma<- (sum( t(alpha) %*% as.numeric(as.matrix(x_test[i,])) + beta))
		if (gamma *  y_test[i] > 1 ) {
		got_right <- got_right+1}
		else{
		got_wrong <- got_wrong +1
}}
acc <- got_right/(got_right + got_wrong)


