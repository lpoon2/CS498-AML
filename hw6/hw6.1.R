library('DAAG')
library('glmnet')
library('MASS')

#Read in data
dfsix <- read.csv("~/CS498-AML/hw6/default_features_1059_tracks.txt", header = FALSE)
x <- dfsix[,1:68]
latitude <- dfsix[,69]
longitude <- dfsix[,70]

#Latitude Lin.reg
latitude_r <- lm(latitude ~ ., as.data.frame(x))
plot(latitude_r)
summary(latitude_r)

#Longtitude Lin.reg
longitude_r <- lm(longitude ~ . ,as.data.frame(x))
plot(longitude_r)
summary(longitude_r)

#Elminate negative values
latitude_d <- latitude + 90
longitude_d <- longitude +180

#Box-cox Latitude
latitude_r_d <- lm(latitude_d~ as.matrix(x))
la_box <- boxcox(latitude_r_d, lambda = seq(-9, 9, 1/10))
lat_lambda <- la_box$x[match(max(la_box$y), la_box$ y)]

#Box-cox Longitude
longitude_r_d <-lm(longitude_d~ as.matrix(x))
lo_box <-boxcox(longitude_r_d, lambda = seq(-9, 9, 1/10)) 
long_lambda <- lo_box$x[match(max(lo_box$y), lo_box$ y)]

###################
# Unregularization 
###################
#Applying best lambda value (Lat.)
latitude_r_d_h <- lm( (latitude_d^(lat_lambda)-1)/lat_lambda ~ ., as.data.frame(x))

#Applying best lambda value (Long.)
longitude_r_d_h <- lm((longitude_d^(long_lambda)-1)/long_lambda ~ ., as.data.frame(x))

cv_lat_r <- attr(cv.lm(as.data.frame(x), latitude_r_d_h), 'ms') #316
num_var <- sum(latitude_r$coefficients == 0) #68

cv_long_r <- attr(cv.lm(as.data.frame(x), longitude_r_d_h), 'ms') #2088
num_var <- sum(longitude_r$coefficients == 0) #68


########################
# Regularization (Lat)
########################
# Ridge (L2)
latitude_model_r <- glmnet(as.matrix(x), (latitude_d^(lat_lambda)-1)/lat_lambda, alpha = 0)
plot(latitude_model_r)
summary(latitude_model_r)
msq_lat_r <- cv.glmnet(as.matrix(x),  (latitude_d^(lat_lambda)-1)/lat_lambda , alpha = 0)
plot(msq_lat_r)
coef_lat_r <- msq_lat_r$lambda.min
error_lat_l2 <- msq_lat_r$cvm[match(min(msq_lat_r$lambda),  msq_lat_r$lambda)]
lat_r_num_var <- length(predict(latitude_model_r, s = coef_lat_r, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(latitude_model_r, s = coef_lat_r, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum(( (predicted*lat_lambda+1)^(1/lat_lambda) - latitude_d)^2)
lat_r_rsq <- 1 - sse / sst #[1] 0.2550039

# Lasso (L1)
latitude_model_l <- glmnet(as.matrix(x),  (latitude_d^(lat_lambda)-1)/lat_lambda, alpha = 1)
plot(latitude_model_l)
summary(latitude_model_l)
msq_lat_l <- cv.glmnet(as.matrix(x),  (latitude_d^(lat_lambda)-1)/lat_lambda , alpha = 1)
plot(msq_lat_l)
coef_lat_l <- msq_lat_l$lambda.min
error_lat_l1 <- msq_lat_l$cvm[match(min( msq_lat_l$lambda),  msq_lat_l$lambda)]
lat_l_num_var <- length(predict(latitude_model_l, s = coef_lat_l, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(latitude_model_l, s = coef_lat_l, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum(((predicted*lat_lambda+1)^(1/lat_lambda) - latitude_d)^2)
lat_l_rsq <- 1 - sse / sst #[1] 0.2270252

#Elastic net (Lat.)
elastic_lat_rsq = c()
elastic_lat_num_var = c()
elastic_lat_lambda = c()
errors_elastic_lat = c()
for (a in c(0.25, 0.5, 0.75)) {
  latitude_model <- glmnet(as.matrix(x),  (latitude_d^(lat_lambda)-1)/lat_lambda , alpha = a)
  summary(latitude_model)
  msq_lat_n <-cv.glmnet(as.matrix(x),  (latitude_d^(lat_lambda)-1)/lat_lambda  , alpha = 0)
  plot(msq_lat_n)
  coef_lat <- msq_lat_n$lambda.min
  errors_elastic_lat <- c(errors_elastic_lat,msq_lat_n$cvm[match(min( msq_lat_n$lambda),  msq_lat_n$lambda)])
  elastic_lat_lambda <- c(elastic_lat_lambda, coef_lat)
  elastic_lat_num_var <- c(elastic_lat_num_var, length(predict(latitude_model, s = coef_lat, newx = as.matrix(x), type=c("nonzero"))[[1]]))
  # R-Squared 
  predicted <- predict(latitude_model, s = coef_lat, newx = as.matrix(x))
  sst <- sum((latitude_d - mean(latitude_d))^2)
  sse <- sum(((predicted*lat_lambda+1)^(1/lat_lambda) - latitude_d)^2)
  elastic_lat_rsq <- c(elastic_lat_rsq, 1 - sse / sst)
} #[1] 0.17737071 0.07507031 0.07229488

########################
# Regularization (Long.)
########################
# Ridge (L2)
longitude_model_r <- glmnet(as.matrix(x), longitude_d^(long_lambda)-1/ long_lambda , alpha = 0)
summary(longitude_model_r)
msq_long_r <- cv.glmnet(as.matrix(x), longitude_d^(long_lambda)-1/ long_lambda , alpha = 0)
plot(msq_long_r)
coef_long_r <- msq_long_r$lambda.min
error_long_l2 <- msq_long_r$cvm[match(min(msq_long_r$lambda), msq_long_r$lambda)]
long_r_num_var <- length(predict(longitude_model_r, s = coef_long_r, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(longitude_model_r, s = coef_long_r, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum(( (predicted*long_lambda+1)^(1/long_lambda)- longitude_d)^2)
long_r_rsq <- 1 - sse / sst #[1] 0.3209327

# Lasso (L1)
longitude_model_l <- glmnet(as.matrix(x),  longitude_d^(long_lambda)-1/ long_lambda, alpha = 1)
summary(longitude_model_l)
msq_long_l<- cv.glmnet(as.matrix(x), longitude_d^(long_lambda)-1/ long_lambda  , alpha = 1)
plot(msq_long_l)
coef_long_l <- msq_long_l$lambda.min
error_long_l1 <- msq_long_l$cvm[match(min(msq_long_l$lambda), msq_long_l$lambda)]
long_l_num_var <- length(predict(longitude_model_l, s = coef_long_l, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(longitude_model_l, s = coef_long_l, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum(((predicted*long_lambda+1)^(1/long_lambda) - longitude_d)^2)
long_l_rsq <- 1 - sse / sst #[1] 0.3165834

#Elastic net (Long.)
elastic_long_rsq = c()
elastic_long_num_var = c()
elastic_long_lambda = c()
errors_elastic_long = c()
for (a in c(0.25, 0.5, 0.75)) {
  longitude_model <- glmnet(as.matrix(x),  longitude_d^(long_lambda)-1/ long_lambda , alpha = a)
  summary(longitude_model)
  msq_long_n <- cv.glmnet(as.matrix(x), longitude_d^(long_lambda)-1/ long_lambda  , alpha = 0)
  plot(msq_long_n)
  coef_long <- msq_long_n$lambda.min
  errors_elastic_long <- c(errors_elastic_long,msq_long_n$cvm[match(min( msq_long_n$lambda),  msq_long_n$lambda)])
  elastic_long_lambda <- c(elastic_long_lambda, coef_long)
  elastic_long_num_var <- c(elastic_long_num_var, length(predict(longitude_model, s = coef_long, newx = as.matrix(x), type=c("nonzero"))[[1]]))
  # R-Squared 
  predicted <- predict(longitude_model, s = coef_long, newx = as.matrix(x))
  sst <- sum((longitude_d - mean(longitude_d))^2)
  sse <- sum(((predicted*long_lambda+1)^(1/long_lambda) - longitude_d)^2)
  elastic_long_rsq <- c(elastic_long_rsq, 1 - sse / sst)
} #[1] 0.2784885 0.2403703 0.2403631

