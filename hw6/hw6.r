dfsix <- read.csv("C:/Users/titus/Documents/CS498/hw6/default_features_1059_tracks.txt", header = FALSE)
x <- dfsix[,1:68]
latitude <- dfsix[,69]
longitude <- dfsix[,70]
latitude_r <- lm(latitude~ as.matrix(x))

plot(latitude_r)
summary(latitude_r)

Call:
lm(formula = latitude ~ as.matrix(x))

Residuals:
    Min      1Q  Median      3Q     Max 
-63.097  -8.514   3.251  10.735  57.224 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)      26.42893    0.49829  53.039  < 2e-16 ***
as.matrix(x)V1    8.40926    3.40035   2.473 0.013563 *  
as.matrix(x)V2   -8.97695    3.52628  -2.546 0.011056 *  
as.matrix(x)V3   -0.73845    1.18594  -0.623 0.533645    
as.matrix(x)V4   -5.37564    1.44915  -3.710 0.000219 ***
as.matrix(x)V5   -0.93804    0.77577  -1.209 0.226885    
as.matrix(x)V6   -0.82038    0.93955  -0.873 0.382784    
as.matrix(x)V7   -0.95169    0.74010  -1.286 0.198781    
as.matrix(x)V8   -0.46184    0.59846  -0.772 0.440463    
as.matrix(x)V9   -1.15243    0.71510  -1.612 0.107374    
as.matrix(x)V10   0.37084    0.65224   0.569 0.569784    
as.matrix(x)V11  -0.28115    0.63727  -0.441 0.659177    
as.matrix(x)V12  -0.17326    0.59794  -0.290 0.772055    
as.matrix(x)V13   0.50648    0.59352   0.853 0.393671    
as.matrix(x)V14   0.08569    0.61871   0.138 0.889875    
as.matrix(x)V15  -0.21006    0.63849  -0.329 0.742228    
as.matrix(x)V16  -2.18976    0.58561  -3.739 0.000195 ***
as.matrix(x)V17   0.31961    0.58859   0.543 0.587240    
as.matrix(x)V18 -11.12633    3.92790  -2.833 0.004710 ** 
as.matrix(x)V19  11.63280    3.74807   3.104 0.001966 ** 
as.matrix(x)V20  -2.92864    1.27833  -2.291 0.022173 *  
as.matrix(x)V21   2.64234    1.39029   1.901 0.057649 .  
as.matrix(x)V22   0.41572    1.03309   0.402 0.687475    
as.matrix(x)V23   1.26278    1.06651   1.184 0.236683    
as.matrix(x)V24  -0.89320    1.15368  -0.774 0.438984    
as.matrix(x)V25   4.05809    1.38297   2.934 0.003420 ** 
as.matrix(x)V26  -4.28043    1.45731  -2.937 0.003388 ** 
as.matrix(x)V27  -2.03835    1.30678  -1.560 0.119121    
as.matrix(x)V28  -1.91211    1.37483  -1.391 0.164600    
as.matrix(x)V29  -0.31849    1.35254  -0.235 0.813889    
as.matrix(x)V30  -3.20769    1.41154  -2.272 0.023272 *  
as.matrix(x)V31   0.39116    1.36161   0.287 0.773961    
as.matrix(x)V32   1.72514    1.53408   1.125 0.261057    
as.matrix(x)V33   3.01590    1.55497   1.940 0.052722 .  
as.matrix(x)V34   1.41805    1.44796   0.979 0.327651    
as.matrix(x)V35  -2.41629    1.65155  -1.463 0.143772    
as.matrix(x)V36   1.91187    1.96917   0.971 0.331835    
as.matrix(x)V37   2.89020    1.07881   2.679 0.007505 ** 
as.matrix(x)V38   0.90255    0.81032   1.114 0.265628    
as.matrix(x)V39  -1.77708    1.03647  -1.715 0.086740 .  
as.matrix(x)V40  -0.41170    0.78104  -0.527 0.598228    
as.matrix(x)V41   0.19013    0.78767   0.241 0.809304    
as.matrix(x)V42  -0.30460    0.94367  -0.323 0.746927    
as.matrix(x)V43  -0.65246    0.90226  -0.723 0.469762    
as.matrix(x)V44  -0.31899    0.90088  -0.354 0.723348    
as.matrix(x)V45   0.22330    0.91189   0.245 0.806602    
as.matrix(x)V46   0.86072    0.93959   0.916 0.359861    
as.matrix(x)V47   1.16886    0.96710   1.209 0.227096    
as.matrix(x)V48   0.03058    1.04002   0.029 0.976550    
as.matrix(x)V49  -0.56738    1.11526  -0.509 0.611050    
as.matrix(x)V50   0.99109    1.14944   0.862 0.388765    
as.matrix(x)V51  -0.27275    0.99835  -0.273 0.784756    
as.matrix(x)V52   2.21275    1.71405   1.291 0.197023    
as.matrix(x)V53  -1.55361    1.72297  -0.902 0.367434    
as.matrix(x)V54  -3.50596    0.78364  -4.474 8.57e-06 ***
as.matrix(x)V55  -3.65760    0.63829  -5.730 1.33e-08 ***
as.matrix(x)V56  -2.15821    0.88083  -2.450 0.014450 *  
as.matrix(x)V57   1.06875    0.72040   1.484 0.138249    
as.matrix(x)V58  -1.20726    0.97836  -1.234 0.217509    
as.matrix(x)V59  -2.81604    1.11218  -2.532 0.011495 *  
as.matrix(x)V60   3.58693    1.20141   2.986 0.002900 ** 
as.matrix(x)V61   1.27068    1.03915   1.223 0.221694    
as.matrix(x)V62   0.84230    1.17082   0.719 0.472057    
as.matrix(x)V63   0.65746    1.15109   0.571 0.568018    
as.matrix(x)V64   0.24431    1.18868   0.206 0.837203    
as.matrix(x)V65   0.84916    1.31853   0.644 0.519711    
as.matrix(x)V66  -1.60406    1.44658  -1.109 0.267759    
as.matrix(x)V67  -2.82392    1.48145  -1.906 0.056915 .  
as.matrix(x)V68  -3.35783    1.41112  -2.380 0.017522 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 16.08 on 990 degrees of freedom
Multiple R-squared:   0.29,	Adjusted R-squared:  0.2413 
F-statistic: 5.947 on 68 and 990 DF,  p-value: < 2.2e-16

summary(longitude_r)

Call:
lm(formula = longitude ~ as.matrix(x))

Residuals:
     Min       1Q   Median       3Q      Max 
-138.603  -25.368    1.488   27.544  125.008 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)      37.8905     1.3167  28.778  < 2e-16 ***
as.matrix(x)V1   -4.8501     8.9850  -0.540 0.589459    
as.matrix(x)V2  -13.8132     9.3178  -1.482 0.138537    
as.matrix(x)V3    8.9160     3.1337   2.845 0.004530 ** 
as.matrix(x)V4  -10.4705     3.8292  -2.734 0.006361 ** 
as.matrix(x)V5  -20.0076     2.0499  -9.760  < 2e-16 ***
as.matrix(x)V6   -7.8442     2.4826  -3.160 0.001628 ** 
as.matrix(x)V7   -1.2258     1.9556  -0.627 0.530944    
as.matrix(x)V8   -6.3032     1.5814  -3.986 7.22e-05 ***
as.matrix(x)V9   -6.6431     1.8896  -3.516 0.000459 ***
as.matrix(x)V10   4.5692     1.7235   2.651 0.008149 ** 
as.matrix(x)V11  -6.2868     1.6839  -3.733 0.000200 ***
as.matrix(x)V12   0.7213     1.5800   0.456 0.648135    
as.matrix(x)V13   2.8362     1.5683   1.808 0.070843 .  
as.matrix(x)V14  -0.6126     1.6349  -0.375 0.707940    
as.matrix(x)V15  -4.3277     1.6871  -2.565 0.010460 *  
as.matrix(x)V16   1.8039     1.5474   1.166 0.243983    
as.matrix(x)V17  -2.6390     1.5553  -1.697 0.090043 .  
as.matrix(x)V18  13.9242    10.3790   1.342 0.180044    
as.matrix(x)V19  -3.3536     9.9038  -0.339 0.734970    
as.matrix(x)V20 -15.9627     3.3778  -4.726 2.62e-06 ***
as.matrix(x)V21  13.2766     3.6737   3.614 0.000317 ***
as.matrix(x)V22 -14.1901     2.7298  -5.198 2.44e-07 ***
as.matrix(x)V23  -1.2615     2.8181  -0.448 0.654514    
as.matrix(x)V24   2.2536     3.0485   0.739 0.459916    
as.matrix(x)V25  -3.2209     3.6543  -0.881 0.378323    
as.matrix(x)V26  -2.3353     3.8508  -0.606 0.544353    
as.matrix(x)V27   8.1880     3.4530   2.371 0.017918 *  
as.matrix(x)V28  -2.0544     3.6328  -0.566 0.571852    
as.matrix(x)V29  -5.6937     3.5739  -1.593 0.111452    
as.matrix(x)V30   1.1142     3.7298   0.299 0.765211    
as.matrix(x)V31   1.9372     3.5979   0.538 0.590409    
as.matrix(x)V32   4.6561     4.0536   1.149 0.250991    
as.matrix(x)V33   0.3397     4.1088   0.083 0.934126    
as.matrix(x)V34   1.6826     3.8261   0.440 0.660206    
as.matrix(x)V35   4.7059     4.3640   1.078 0.281151    
as.matrix(x)V36   8.7837     5.2033   1.688 0.091707 .  
as.matrix(x)V37  -5.9261     2.8506  -2.079 0.037886 *  
as.matrix(x)V38   4.8469     2.1412   2.264 0.023809 *  
as.matrix(x)V39   4.3444     2.7387   1.586 0.113000    
as.matrix(x)V40   0.7700     2.0638   0.373 0.709168    
as.matrix(x)V41  -1.1133     2.0813  -0.535 0.592838    
as.matrix(x)V42   2.2664     2.4935   0.909 0.363618    
as.matrix(x)V43  -0.8050     2.3841  -0.338 0.735699    
as.matrix(x)V44   1.0145     2.3805   0.426 0.670060    
as.matrix(x)V45   1.5380     2.4096   0.638 0.523446    
as.matrix(x)V46   0.5009     2.4828   0.202 0.840140    
as.matrix(x)V47  -1.7778     2.5555  -0.696 0.486794    
as.matrix(x)V48  -2.4671     2.7481  -0.898 0.369536    
as.matrix(x)V49  -0.9291     2.9470  -0.315 0.752607    
as.matrix(x)V50  -0.3245     3.0373  -0.107 0.914925    
as.matrix(x)V51  -0.5580     2.6380  -0.212 0.832521    
as.matrix(x)V52 -12.4486     4.5292  -2.749 0.006095 ** 
as.matrix(x)V53  -1.9978     4.5527  -0.439 0.660896    
as.matrix(x)V54  -0.3355     2.0707  -0.162 0.871327    
as.matrix(x)V55   1.5871     1.6866   0.941 0.346928    
as.matrix(x)V56   5.0527     2.3275   2.171 0.030177 *  
as.matrix(x)V57   4.3758     1.9036   2.299 0.021727 *  
as.matrix(x)V58   6.4523     2.5852   2.496 0.012726 *  
as.matrix(x)V59  -2.2736     2.9388  -0.774 0.439317    
as.matrix(x)V60   8.4217     3.1746   2.653 0.008109 ** 
as.matrix(x)V61  -9.6381     2.7458  -3.510 0.000468 ***
as.matrix(x)V62  -0.7134     3.0938  -0.231 0.817685    
as.matrix(x)V63   0.3590     3.0416   0.118 0.906076    
as.matrix(x)V64   0.4096     3.1409   0.130 0.896278    
as.matrix(x)V65   1.6578     3.4841   0.476 0.634308    
as.matrix(x)V66  -2.0052     3.8224  -0.525 0.599991    
as.matrix(x)V67  -0.5080     3.9146  -0.130 0.896779    
as.matrix(x)V68  -0.9083     3.7287  -0.244 0.807588    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 42.49 on 990 degrees of freedom
Multiple R-squared:  0.3355,	Adjusted R-squared:  0.2899 
F-statistic: 7.352 on 68 and 990 DF,  p-value: < 2.2e-16

latitude_d <- latitude + 90
longitude_d <- longitude +180
latitude_r_d <- lm(latitude_d~ as.matrix(x))
boxCox(latitude_r_d)



latitude_r_d <- lm(latitude_d~ as.matrix(x))

longitude_r_d <-lm(longitude_d~ as.matrix(x))
boxCox(longitude_r_d) #(max at 0, nothing to do )

latitude_r_d_h <- lm(latitude_d^(1/2) ~ as.matrix(x))

summary(latitude_r_d_h)

Call:
lm(formula = latitude_d^(1/2) ~ as.matrix(x))

Residuals:
    Min      1Q  Median      3Q     Max 
-3.4156 -0.3875  0.1589  0.5074  2.9813 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)     10.753112   0.024483 439.202  < 2e-16 ***
as.matrix(x)V1   0.425172   0.167076   2.545 0.011085 *  
as.matrix(x)V2  -0.449735   0.173263  -2.596 0.009580 ** 
as.matrix(x)V3  -0.042973   0.058271  -0.737 0.461011    
as.matrix(x)V4  -0.255222   0.071204  -3.584 0.000354 ***
as.matrix(x)V5  -0.050285   0.038117  -1.319 0.187404    
as.matrix(x)V6  -0.039901   0.046164  -0.864 0.387614    
as.matrix(x)V7  -0.045755   0.036365  -1.258 0.208605    
as.matrix(x)V8  -0.021387   0.029405  -0.727 0.467204    
as.matrix(x)V9  -0.056512   0.035136  -1.608 0.108071    
as.matrix(x)V10  0.021286   0.032048   0.664 0.506730    
as.matrix(x)V11 -0.015964   0.031312  -0.510 0.610280    
as.matrix(x)V12 -0.010896   0.029380  -0.371 0.710826    
as.matrix(x)V13  0.030638   0.029162   1.051 0.293703    
as.matrix(x)V14  0.004360   0.030400   0.143 0.885992    
as.matrix(x)V15 -0.011921   0.031372  -0.380 0.704032    
as.matrix(x)V16 -0.100647   0.028774  -3.498 0.000490 ***
as.matrix(x)V17  0.009558   0.028920   0.330 0.741094    
as.matrix(x)V18 -0.524858   0.192997  -2.720 0.006652 ** 
as.matrix(x)V19  0.553870   0.184160   3.008 0.002700 ** 
as.matrix(x)V20 -0.140596   0.062810  -2.238 0.025415 *  
as.matrix(x)V21  0.123466   0.068312   1.807 0.071004 .  
as.matrix(x)V22  0.025687   0.050761   0.506 0.612934    
as.matrix(x)V23  0.055414   0.052403   1.057 0.290553    
as.matrix(x)V24 -0.041040   0.056686  -0.724 0.469247    
as.matrix(x)V25  0.194984   0.067952   2.869 0.004199 ** 
as.matrix(x)V26 -0.216789   0.071605  -3.028 0.002529 ** 
as.matrix(x)V27 -0.097089   0.064208  -1.512 0.130828    
as.matrix(x)V28 -0.087861   0.067552  -1.301 0.193684    
as.matrix(x)V29 -0.015065   0.066457  -0.227 0.820714    
as.matrix(x)V30 -0.145172   0.069356  -2.093 0.036589 *  
as.matrix(x)V31  0.019184   0.066903   0.287 0.774371    
as.matrix(x)V32  0.080103   0.075377   1.063 0.288175    
as.matrix(x)V33  0.142711   0.076403   1.868 0.062076 .  
as.matrix(x)V34  0.066813   0.071145   0.939 0.347908    
as.matrix(x)V35 -0.123860   0.081149  -1.526 0.127245    
as.matrix(x)V36  0.094454   0.096755   0.976 0.329193    
as.matrix(x)V37  0.142272   0.053007   2.684 0.007396 ** 
as.matrix(x)V38  0.054690   0.039815   1.374 0.169876    
as.matrix(x)V39 -0.090684   0.050927  -1.781 0.075272 .  
as.matrix(x)V40 -0.022192   0.038376  -0.578 0.563213    
as.matrix(x)V41  0.017803   0.038702   0.460 0.645612    
as.matrix(x)V42 -0.007341   0.046367  -0.158 0.874236    
as.matrix(x)V43 -0.034066   0.044332  -0.768 0.442416    
as.matrix(x)V44 -0.020689   0.044265  -0.467 0.640321    
as.matrix(x)V45  0.011103   0.044806   0.248 0.804342    
as.matrix(x)V46  0.037776   0.046167   0.818 0.413414    
as.matrix(x)V47  0.054701   0.047518   1.151 0.249944    
as.matrix(x)V48  0.004393   0.051101   0.086 0.931514    
as.matrix(x)V49 -0.023931   0.054798  -0.437 0.662420    
as.matrix(x)V50  0.050065   0.056477   0.886 0.375589    
as.matrix(x)V51 -0.014429   0.049054  -0.294 0.768700    
as.matrix(x)V52  0.102730   0.084220   1.220 0.222836    
as.matrix(x)V53 -0.065673   0.084658  -0.776 0.438084    
as.matrix(x)V54 -0.167805   0.038504  -4.358 1.45e-05 ***
as.matrix(x)V55 -0.202359   0.031362  -6.452 1.72e-10 ***
as.matrix(x)V56 -0.096019   0.043279  -2.219 0.026741 *  
as.matrix(x)V57  0.051048   0.035397   1.442 0.149572    
as.matrix(x)V58 -0.063368   0.048071  -1.318 0.187742    
as.matrix(x)V59 -0.138018   0.054647  -2.526 0.011704 *  
as.matrix(x)V60  0.177232   0.059031   3.002 0.002746 ** 
as.matrix(x)V61  0.062290   0.051058   1.220 0.222761    
as.matrix(x)V62  0.035305   0.057528   0.614 0.539560    
as.matrix(x)V63  0.033801   0.056559   0.598 0.550229    
as.matrix(x)V64  0.012974   0.058405   0.222 0.824249    
as.matrix(x)V65  0.039992   0.064786   0.617 0.537185    
as.matrix(x)V66 -0.077940   0.071078  -1.097 0.273104    
as.matrix(x)V67 -0.137795   0.072791  -1.893 0.058645 .  
as.matrix(x)V68 -0.156410   0.069335  -2.256 0.024296 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.7901 on 990 degrees of freedom
Multiple R-squared:  0.2838,	Adjusted R-squared:  0.2346 
F-statistic:  5.77 on 68 and 990 DF,  p-value: < 2.2e-16


latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 0)
plot(latitude_ra)
summary(latitude_ra)
          Length Class     Mode   
a0         100   -none-    numeric
beta      6800   dgCMatrix S4     
df         100   -none-    numeric
dim          2   -none-    numeric
lambda     100   -none-    numeric
dev.ratio  100   -none-    numeric
nulldev      1   -none-    numeric
npasses      1   -none-    numeric
jerr         1   -none-    numeric
offset       1   -none-    logical
call         4   -none-    call   
nobs         1   -none-    numeric


#alpha=0 is ridge, alpha= 1 is lasso
latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)    , alpha = 0)
plot(latitude_ra)
latitude_ra_fit <- cv.glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 0)
plot(latitude_ra_fit)
opt_lambda <- latitude_ra_fit$lambda.min
opt_lambda
#[1] 0.27817
nonzero_value <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 68
y_predicted <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((y_predicted^2 - latitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.2491186

longitude_ra <- glmnet(as.matrix(x), longitude_d  , alpha = 0)
plot(longitude_ra)
longitude_ra_fit <- cv.glmnet(as.matrix(x), longitude_d  , alpha = 0)
plot(longitude_ra_fit)
opt_lambda <- longitude_ra_fit$lambda.min
opt_lambda
#[1] 3.360084
nonzero_value <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 68
y_predicted <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((y_predicted - longitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.3224724


latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)    , alpha = 1)
plot(latitude_ra)
latitude_ra_fit <- cv.glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 1)
plot(latitude_ra_fit)
opt_lambda <- latitude_ra_fit$lambda.min
opt_lambda
#[1] 0.02419381
nonzero_value <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 20
y_predicted <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((y_predicted^2 - latitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.2254387


longitude_ra_fit <- cv.glmnet(as.matrix(x), longitude_d  , alpha = 1)
plot(longitude_ra_fit)
opt_lambda <- longitude_ra_fit$lambda.min
opt_lambda
#[1] 0.292243
longitude_ra <- glmnet(as.matrix(x), longitude_d  , alpha = 1)
nonzero_value <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
#[1] 50
length(nonzero_value[[1]])
y_predicted <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((y_predicted - longitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.32164

#alpha = 0.25

latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)    , alpha = 0.25)
latitude_ra_fit <- cv.glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 0.25)
opt_lambda <- latitude_ra_fit$lambda.min
opt_lambda
#[1] 0.08034449
nonzero_value <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 23
y_predicted <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((y_predicted^2 - latitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.2290678

longitude_ra_fit <- cv.glmnet(as.matrix(x), longitude_d  , alpha = 0.25)
opt_lambda <- longitude_ra_fit$lambda.min
opt_lambda
#[1] 0.970501
longitude_ra <- glmnet(as.matrix(x), longitude_d  , alpha = 0.25)
nonzero_value <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
#[1] 55
length(nonzero_value[[1]])
y_predicted <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((y_predicted - longitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.3237264


#alpha = 0.5

latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)    , alpha = 0.5)
latitude_ra_fit <- cv.glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 0.5)
opt_lambda <- latitude_ra_fit$lambda.min
opt_lambda
#[1] 0.04838761
nonzero_value <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 21
y_predicted <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((y_predicted^2 - latitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.2267553

longitude_ra_fit <- cv.glmnet(as.matrix(x), longitude_d  , alpha = 0.5)
opt_lambda <- longitude_ra_fit$lambda.min
opt_lambda
#[1] 0.772656
longitude_ra <- glmnet(as.matrix(x), longitude_d  , alpha = 0.5)
nonzero_value <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
#[1] 48
length(nonzero_value[[1]])
y_predicted <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((y_predicted - longitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.3167748



#alpha = 0.75

latitude_ra <- glmnet(as.matrix(x), latitude_d^(1/2)    , alpha = 0.75)
latitude_ra_fit <- cv.glmnet(as.matrix(x), latitude_d^(1/2)  , alpha = 0.75)
opt_lambda <- latitude_ra_fit$lambda.min
opt_lambda
#[1] 0.03225841
nonzero_value <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
length(nonzero_value[[1]])
#[1] 20
y_predicted <- predict(latitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((latitude_d - mean(latitude_d))^2)
sse <- sum((y_predicted^2 - latitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1] 0.227459

longitude_ra_fit <- cv.glmnet(as.matrix(x), longitude_d  , alpha = 0.75)
opt_lambda <- longitude_ra_fit$lambda.min
opt_lambda
#[1] 0.6204446
longitude_ra <- glmnet(as.matrix(x), longitude_d  , alpha = 0.75)
nonzero_value <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x), type=c("nonzero"))
#[1] 43
length(nonzero_value[[1]])
y_predicted <- predict(longitude_ra, s = opt_lambda, newx = as.matrix(x))
sst <- sum((longitude_d - mean(longitude_d))^2)
sse <- sum((y_predicted - longitude_d)^2)
rsq <- 1 - sse / sst
rsq
#[1]  0.3123789