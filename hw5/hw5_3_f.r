library('glmnet')
df <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data", header = FALSE)
x <- df[,1:8]
y <- df[,9]
x[,1]<- factor(x[,1])
x[,1]<- as.numeric(x[,1])
xdf <- as.matrix(x)
cvfit = cv.glmnet(xdf, y)
plot(cvfit)
