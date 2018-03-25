library(gdata)
library('glmnet')
library('MASS')
library('caret')
dfsix2 <- read.xls("~/CS498-AML/hw6/default.xls", header = TRUE)
dfsix2 <- dfsix2[-c(1),]
y <- as.numeric(paste(dfsix2[,25]))
x <- dfsix2[,-c(1,25)]

#reformat datat frame
for (i in 1:23){
  x[i] <- as.numeric(paste(x[[i]]))
}

acc_train  <- c()
acc_test  <- c()
for (i in c(0, 0.25, 0.5, 0.75, 1)) {
  temp_acc_train  <- c()
  temp_acc_test  <- c()
  n_folds <- 10
  folds_i <- sample(rep(1:n_folds, length.out = 30000*0.8))
  cv_tmp <- matrix(NA, nrow = n_folds, ncol = length(df))
  for (k in 1:n_folds) {
    test_i <- which(folds_i == k)
    # train/test split
    train_x <- x[-test_i,]
    test_x <- x[test_i,]
    train_y <- y[-test_i]
    test_y <- y[test_i]
    
    #training model 
    l1_model <- glmnet(as.matrix(train_x), train_y , alpha = i, family="binomial")
    l1_model_cv <- cv.glmnet(as.matrix(train_x), train_y, alpha = i,family="binomial")
    l1_lambda <- l1_model_cv$lambda.min
    plot(l1_model_cv)
    print(paste('Using lambda value :',l1_lambda))
  
    #accuracy on trainging
    predicted <- predict(l1_model, s = l1_lambda, newx = as.matrix(train_x))
    predicted <- ifelse(predicted > 0.5,1,0)
    misClasificError <- mean(predicted != train_y)
    print(paste('Accuracy on training set',1-misClasificError))
    temp_acc_train <- c(temp_acc_train,1-misClasificError) 
    
    #accuracy on testing
    predicted <- predict(l1_model, s = l1_lambda, newx = as.matrix(test_x))
    predicted <- ifelse(predicted > 0.5,1,0)
    misClasificError <- mean(predicted != test_y)
    print(paste('Accuracy on testing set',1-misClasificError))
    temp_acc_test <- c(temp_acc_test,1-misClasificError) 
    
  }
  acc_train  <- c(acc_train, mean(temp_acc_train))
  acc_test  <- c(acc_test,mean(temp_acc_test))
}
