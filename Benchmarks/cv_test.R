library(iregnet)

predict_accuracy <- function(X, Y, fam){
  smp_size <- floor(0.75 * nrow(X))
  set.seed(123)
  train_ind <- sample(seq_len(nrow(X)), size = smp_size)
  X_train <- X[train_ind,] 
  X_test <- X[-train_ind,]
  Y_train <- Y[train_ind,] 
  Y_test <- Y[-train_ind,]
  cv_fit <- cv.iregnet(X_train, Y_train, family = fam, nfolds = 5L)
  plot(cv_fit)
  min.idx <- cv_fit$selected[1]
  sd.idx <- cv_fit$selected[2]
  
  Y_predicted <- predict(cv_fit, newx = X_test, type = "response", lambda.type = "min")
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with min lambda:", (correct/nrow(Y_test))*100)
  
  Y_predicted <- predict(cv_fit, newx = X_test, type = "response", lambda.type = "1sd")
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with lambda at 1sd:", (correct/nrow(Y_test))*100)
}

plot(X)
X <- matrix(rnorm(1000), nrow = 100, ncol = 10)
Y <- rweibull(100, shape=0.75, scale=1)
Y <- matrix(Y, nrow = 100, ncol = 1)
Y <- cbind(Y, Y)
fit <- iregnet(X, Y, family = "weibull")
fit_cv <- cv.iregnet(X, Y, family = "gaussian", nfolds = 5L)
plot(fit)

family = "weibull"

y <- rnorm(100, sd = 0)

if (family %in% names(transformed_distributions)) {
  trans <- transformed_distributions[[family]]
  y <- trans$trans(y)
  family <- trans$dist
}


tets <- data.weibull(1000, shape = 2, regco = c(1, 3), rcen = 0.25, ncorvar = 3, 
             correlated = FALSE)

X <- matrix(rnorm(1000), ncol=5, nrow=200)
Y <- rnorm(200)
Y <- cbind(Y,Y)
X <- neuroblastomaProcessed$feature.mat
Y <- neuroblastomaProcessed$target.mat
predict_accuracy(X, Y, "gaussian")

