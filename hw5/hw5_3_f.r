df <- read.csv("C:/Users/titus/Documents/CS498/hw5/abalone.DATA", header = FALSE)
x <- df[,1:8]
y <- df[,9]
x[,1]<- factor(x[,1])
x[,1]<- as.numeric(x[,1])
library(glmnet)
install.packages("glmnet", repos = "http://cran.us.r-project.org")
cvfit = cv.glmnet(x, y)
plot(cvfit)

