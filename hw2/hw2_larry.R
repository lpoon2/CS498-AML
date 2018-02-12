library(klaR)
library(caret)
library(plyr)
#selecting continous data 
parseData <- function() {
  trData <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", header= F)
  tsData <- read.csv("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.test", header = F)
  
  tsData <- tsData[-1,]
  
  mergeData <<-rbind(trData, tsData)
  
  train_idx<- createDataPartition(y=mergeData$V15, p=.8, list=FALSE)
  
  trData <- mergeData[train_idx,]
  tsData <- mergeData[-train_idx,]
  
  test_idx<- createDataPartition(y=tsData$V15, p=.5, list=FALSE)
  
  tsData <- tsData[test_idx,]
  vData <- tsData[-test_idx,]
  
  
  trLabel <<- trData$V15
  tsLabel <<- tsData$V15
  vLabel <<- vData$V15
  levels (trLabel) <- c(-1, 1, 0 , -1, 1)
  levels (tsLabel) <- c(-1, 1, 0 , -1, 1)
  levels (vLabel) <- c(-1, 1, 0 , -1, 1)
  
  trData <<- trData[,c(1,3,5,11,12,13)]
  tsData <<- tsData[,c(1,3,5,11,12,13)]
  vData <<- vData[,c(1,3,5,11,12,13)]
  
  for (i in 1:6) {
    trData[,i] =as.numeric(trData[,i])
    tsData[,i] =as.numeric(tsData[,i])
    vData[,i] =as.numeric(vData[,i])
  }
  
  scaledTr <<- scale(trData)
  scaledTs <<- scale(tsData)
  scaledV <<- scale(vData)
  
  trLabel <- as.numeric(trLabel) 
  trLabel <- replace (as.numeric(trLabel) ,as.numeric(trLabel) == 1 , -1)
  trLabel <- replace (as.numeric(trLabel) ,as.numeric(trLabel) == 2 , 1)
  
  vLabel <- as.numeric(vLabel) 
  vLabel <- replace (as.numeric(vLabel) ,as.numeric(vLabel) == 1 , -1)
  vLabel <- replace (as.numeric(vLabel) ,as.numeric(vLabel) == 2 , 1)
} 

#################################
# Testing on validation set
#################################

calAccuracy <- function(a, b, validations, labels) {
  correct <- 0  
  for ( j in 1:length(validations[,1])) {
    dp <- sample(1:length(validations[,1]), 1)
    guess <- a %*% validations[dp,] + b 
    res <- guess * labels[dp]
    if(res > 0) {
      correct <- correct + 1 
    }
  }
  acc =  correct/length(validations[,1])
  mag_a = norm(a, type="2")
  #print(acc) 
  return(acc) 
}

#####################################################
# Training modes of different regularization constant
#####################################################
lambdas = c(0.0001, 0.0004, 0.0008, 0.001)
perfL <<- c()
perf_total <<- c()
mag_lamb <<- c()

for (lambda in lambdas){
  perf <<- c() 
  print(lambda)
  a <- matrix(0, ncol = 6)
  b <- runif(1, 0, 1)
  
  for (epoch in 1:50) {

    stepLen <- 1/(0.01 * epoch + 50 )
    
    for (step in 1:300) {
      ridx <- sample(1:length(scaledTr[,1]),1 )
      x_i  <- scaledTr[ridx,]
      y_i <- trLabel[ridx]
      if ((y_i * ((a %*% x_i) +b)) >= 1){
        a <- a - stepLen*(lambda*a) 
        b <- b - stepLen*0
      } else {
        a <- a - stepLen * (lambda*a - y_i*x_i)
        b <- b - stepLen * (-y_i) 
      }
      
      if (step %% 30 == 0) {
        # separate 50 samples 
        correct = 0  
        for ( j in 1:50) {
          dp <- sample(1:length(scaledTr[,1]), 1)
          guess <- a %*% scaledTr[dp,] + b 
          res <- guess * trLabel[dp]

          if(res > 0) {
            correct = correct + 1 
          }
        }
        acc =  correct/50
        perf <<- c(perf , acc)
        mag_lamb <<- c(mag_lamb,sqrt(sum(a^2)))

      }
  
    }
    
  }
  
  perf_total <<- c(perf_total,perf)
  print("================ testing with validation set ==================")
  lamb_acc <- calAccuracy(a,b,scaledV, vLabel)
  perfL <<- c(perfL, lamb_acc)
  print(lamb_acc)
}



#################################
# Ploting steps and magnitudes
#################################

lineColors <<-c(553,27, 47, 621)
for (i in 1:4) {
  perf_total <- matrix(perf_total, ncol = 500)
  if (i == 1) {
    plot(1:500, perf_total[i,],type="l", col= lineColors[i], xlab="Steps", ylab="Accuracy")
  } else {
    lines(1:500, perf_total[i,], type="l", col= lineColors[i])  
  }
}

legend(400,0.55, legend = lambdas, title="Regularization Constant", col= lineColors,lty=1:2, cex=0.8,box.lty=0)



g <- matrix(mag_lamb, ncol=500)
plot(1:500, g[1,],type="l", col= lineColors[1], xlab="Steps", ylab="Magnitude ")
lines(1:500, perf_total[2,], type="l", col= lineColors[2])  
lines(1:500, perf_total[3,], type="l", col= lineColors[3])  
lines(1:500, perf_total[4,], type="l", col= lineColors[4]) 
legend(400,2.1, legend = lambdas, title="Regularization Constant", col= lineColors,lty=1:2, cex=0.8,box.lty=0)

