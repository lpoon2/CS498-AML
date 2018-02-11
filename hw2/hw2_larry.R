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
  
} 
calAccuracy <- function(a, validations, labels) {
  correct = 0  
  for ( j in 1:length(validations[,1])) {
    guess <- a %*% validations[j,] + b 
    res <- guess * labels[j]
    if(res > 0) {
      correct = correct + 1 
    }
  }
  acc =  correct/length(validations[,1])
  mag_a = norm(a, type="2")
  #print(acc) 
  return(acc) 
}

lambdas = c(0.0001, 0.001,0.01, 1)
perfL <<- c()
perf_total <<- c()
for (lambda in lambdas){
  perf <<- c() 
  print(lambda)
  a <- matrix(0, ncol = 6)
  b <- runif(1, 0, 1)
  firstPlot <- T
  for (epoch in 1:50) {
    # separate 50 samples 
    idx <- sample(1:length(scaledTr[,1]),50)
    valid <- scaledTr[idx, ]
    epochTr <- scaledTr[-idx, ]
    validLabels <- as.numeric(trLabel[idx]) 
    validLabels <- replace (as.numeric(validLabels) ,as.numeric(validLabels) == 1 , -1)
    validLabels <- replace (as.numeric(validLabels) ,as.numeric(validLabels) == 2 , 1)  
    epochLabel <- as.numeric(trLabel[-idx]) 
    epochLabel <- replace (as.numeric(epochLabel) ,as.numeric(epochLabel) == 1 , -1)
    epochLabel <- replace (as.numeric(epochLabel) ,as.numeric(epochLabel) == 2 , 1)
    vLabel <- as.numeric(vLabel) 
    vLabel <- replace (as.numeric(vLabel) ,as.numeric(vLabel) == 1 , -1)
    vLabel <- replace (as.numeric(vLabel) ,as.numeric(vLabel) == 2 , 1)
    
    stepLen <- 1/(0.01 * epoch + 50 )
    
    for (step in 1:600) {
      ridx <- sample(1: length(epochTr[,1]),1 )
      x_i  <- epochTr[ridx,]
      y_i <- epochLabel[ridx]
      if ((y_i * (a %*% x_i) +b) >= 1){
        a = a - stepLen*lambda*a 
        b = b - stepLen*0
      } else {
        a = a - stepLen * (lambda*a - y_i*x_i)
        b = b - stepLen * (-y_i) 
      }
      
      if (step %% 30 == 0) {
        perf <<- c(perf , calAccuracy(a, valid, validLabels))
      }
  
    }
    
  }
  perf_total <<- c(perf_total,perf)
  print(length(perf_total))
  print("================ testing with validation set ==================")
  lamb_acc <- calAccuracy(a,scaledV, vLabel)
  perfL <<- c(perfL, lamb_acc)
  print(lamb_acc)
}
lineColors <<-c()
for (i in 1:4) {
  perf_total <- matrix(perf_total, ncol = 500)
  color <- sample(1:657, 1)
  lineColors <- c(lineColors,29+i)
  if (i == 1) {
    plot(1:1000, perf_total[i,],type="l", col= 29+i, xlab="Steps", ylab="Accuracy")
  } else {
    lines(1:1000, perf_total[i,], type="l", col= 29+i)  
  }
}

legend(430,0.6, legend = lambdas, col= lineColors,lty=1:2, cex=0.8,box.lty=0)




