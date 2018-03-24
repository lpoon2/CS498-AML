#Titus -> C:/Users/titus/Documents/CS498/hw6/default_features_1059_tracks.txt
#Read in data
dfsix <- read.csv("~/CS498-AML/hw6/data/default_features_1059_tracks.txt", header = FALSE)
x <- dfsix[,1:68]
latitude <- dfsix[,69]
longitude <- dfsix[,70]

#Latitude Lin.reg
latitude_r <- lm(latitude~ as.matrix(x))
plot(latitude_r)
summary(latitude_r)

#Longtitude Lin.reg
longitude_r <- lm(longitude~ as.matrix(x))
plot(longitude_r)
summary(longitude_r)

#Elminate negative values
latitude_d <- latitude + 90
longitude_d <- longitude +180

library('MASS')

#Box-cox Latitude
latitude_r_d <- lm(latitude_d~ as.matrix(x))
la_box <- boxcox(latitude_r_d, lambda = seq(0, 9, 1/10))
lat_lambda <- la_box$x[match(max(la_box$y), la_box$ y)]

#Box-cox Longitude
longitude_r_d <-lm(longitude_d~ as.matrix(x))
lo_box <-boxcox(longitude_r_d, lambda = seq(-2, 2, 1/10)) 
long_lambda <- lo_box$x[match(max(lo_box$y), lo_box$ y)]

#Applying best lambda value (Lat.)
latitude_r_d_h <- lm(latitude_d^(1/lat_lambda) ~ as.matrix(x))
plot(latitude_r_d_h)
summary(latitude_r_d_h)

#Applying best lambda value (Long.)
longitude_r_d_h <- lm(longitude_d^(1/long_lambda) ~ as.matrix(x))
plot(longitude_r_d_h)
summary(longitude_r_d_h)

library('glmnet')

########################
# Regularization (Lat)
########################
# Ridge (L2)
latitude_model_r <- glmnet(as.matrix(x), latitude_d^(1/lat_lambda)  , alpha = 0)
plot(latitude_model_r)
summary(latitude_model_r)
msq_lat_r <- cv.glmnet(as.matrix(x), latitude_d^(1/lat_lambda)  , alpha = 0)
coef_lat_r <- msq_lat_r$lambda.min
lat_r_num_var <- length(predict(latitude_model_r, s = coef_lat_r, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(latitude_model_r, s = coef_lat_r, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((predicted^lat_lambda - latitude_d)^2)
lat_r_rsq <- 1 - sse / sst #[1] 0.2550039

# Lasso (L1)
latitude_model_l <- glmnet(as.matrix(x), latitude_d^(1/lat_lambda), alpha = 1)
plot(latitude_model_l)
summary(latitude_model_l)
msq_lat_l <- cv.glmnet(as.matrix(x), latitude_d^(1/lat_lambda)  , alpha = 1)
coef_lat_l <- msq_lat_l$lambda.min
lat_l_num_var <- length(predict(latitude_model_l, s = coef_lat_l, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(latitude_model_l, s = coef_lat_l, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((predicted^lat_lambda - latitude_d)^2)
lat_l_rsq <- 1 - sse / sst #[1] 0.2270252

#Elastic net (Lat.)
elastic_lat_rsq = c()
elastic_lat_num_var = c()
elastic_lat_lambda = c()
for (a in c(0.25, 0.5, 0.75)) {
  latitude_model <- glmnet(as.matrix(x), latitude_d^(1/lat_lambda)  , alpha = a)
  summary(latitude_model)
  msq_lat_n <-cv.glmnet(as.matrix(x), latitude_d^(1/lat_lambda)  , alpha = 0)
  plot(msq_lat_n)
  coef_lat <- msq_lat_n$lambda.min
  elastic_lat_lambda <- c(elastic_lat_lambda, coef_lat)
  elastic_lat_num_var <- c(elastic_lat_num_var, length(predict(latitude_model, s = coef_lat, newx = as.matrix(x), type=c("nonzero"))[[1]]))
  # R-Squared 
  predicted <- predict(latitude_model, s = coef_lat, newx = as.matrix(x))
  sst <- sum((latitude_d - mean(latitude_d))^2)
  sse <- sum((predicted^lat_lambda - latitude_d)^2)
  elastic_lat_rsq <- c(elastic_lat_rsq, 1 - sse / sst)
} #[1] 0.17737071 0.07507031 0.07229488

########################
# Regularization (Long.)
########################
# Ridge (L2)
longitude_model_r <- glmnet(as.matrix(x), longitude_d^(1/long_lambda)  , alpha = 0)
plot(longitude_model_r)
summary(longitude_model_r)
msq_long_r <- cv.glmnet(as.matrix(x), longitude_d^(1/long_lambda)  , alpha = 0)
coef_long_r <- msq_long_r$lambda.min
long_r_num_var <- length(predict(longitude_model_r, s = coef_long_r, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(longitude_model_r, s = coef_long_r, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((predicted^long_lambda - longitude_d)^2)
long_r_rsq <- 1 - sse / sst #[1] 0.3209327

# Lasso (L1)
longitude_model_l <- glmnet(as.matrix(x), longitude_d^(1/long_lambda), alpha = 1)
plot(longitude_model_l)
summary(longitude_model_l)
msq_long_l<- cv.glmnet(as.matrix(x), longitude_d^(1/long_lambda)  , alpha = 1)
coef_long_l <- msq_long_l$lambda.min
long_l_num_var <- length(predict(longitude_model_l, s = coef_long_l, newx = as.matrix(x), type=c("nonzero"))[[1]])
# R-Squared 
predicted <- predict(longitude_model_l, s = coef_long_l, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((predicted^long_lambda - longitude_d)^2)
long_l_rsq <- 1 - sse / sst #[1] 0.3165834

#Elastic net (Long.)
elastic_long_rsq = c()
elastic_long_num_var = c()
elastic_long_lambda = c()
for (a in c(0.25, 0.5, 0.75)) {
  longitude_model <- glmnet(as.matrix(x), longitude_d^(1/long_lambda)  , alpha = a)
  summary(longitude_model)
  msq_long_n <- cv.glmnet(as.matrix(x), longitude_d^(1/long_lambda)  , alpha = 0)
  plot(msq_long_n)
  coef_long <- msq_long_n$lambda.min
  elastic_long_lambda <- c(elastic_long_lambda, coef_long)
  elastic_long_num_var <- c(elastic_long_num_var, length(predict(longitude_model, s = coef_long, newx = as.matrix(x), type=c("nonzero"))[[1]]))
  # R-Squared 
  predicted <- predict(longitude_model, s = coef_long, newx = as.matrix(x))
  sst <- sum((longitude_d - mean(longitude_d))^2)
  sse <- sum((predicted^long_lambda - longitude_d)^2)
  elastic_long_rsq <- c(elastic_long_rsq, 1 - sse / sst)
} #[1] 0.2784885 0.2403703 0.2403631

