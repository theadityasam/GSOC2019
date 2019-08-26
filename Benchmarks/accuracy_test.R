library(iregnet)
library(data.table)
library(penaltyLearning)


predict_accuracy_iregnet <- function(X, Y, lambda){
  smp_size <- floor(0.75 * nrow(X))
  set.seed(123)
  train_ind <- sample(seq_len(nrow(X)), size = smp_size)
  X_train <- X[train_ind,] 
  X_test <- X[-train_ind,]
  Y_train <- Y[train_ind,] 
  Y_test <- Y[-train_ind,]
  cv_fit <- cv.iregnet(X_train, Y_train, nfolds = 5L, family = "gaussian")
  plot(cv_fit)
  min.idx <- cv_fit$selected[1]
  sd.idx <- cv_fit$selected[2]
  
  #fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[min.idx])
  Y_predicted <- predict(fit, newx = X_test, type = "response", lambda = cv_fit$lambda[min.idx])
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with min lambda:", (correct/nrow(Y_test))*100)
  #fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[sd.idx])
  Y_predicted <- predict(fit, newx = X_test, type = "response", lambda = cv_fit$lambda[sd.idx])
  
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with lambda at 1sd:", (correct/nrow(Y_test))*100)
}

predict_accuracy_glmnet(X, Y){
  smp_size <- floor(0.75 * nrow(X))
  set.seed(123)
  train_ind <- sample(seq_len(nrow(X)), size = smp_size)
  X_train <- X[train_ind,] 
  X_test <- X[-train_ind,]
  Y_train <- Y[train_ind,] 
  Y_test <- Y[-train_ind,]
  cv_fit <- cv.glmnet(X_train, Y_train, nfolds = 5L, family = "gaussian")
  plot(cv_fit)
  min.idx <- cv_fit$selected[1]
  sd.idx <- cv_fit$selected[2]
  
  #fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[min.idx])
  Y_predicted <- predict(fit, newx = X_test, type = "response", lambda=cv_fit$lambda[min.idx])
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with min lambda:", (correct/nrow(Y_test))*100)
  #fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[sd.idx])
  Y_predicted <- predict(fit, newx = X_test, type = "response")
  
  correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
  cat("Accuracy with lambda at 1sd:", (correct/nrow(Y_test))*100)
}

# neuroblastomaProcessed

data("neuroblastomaProcessed")
X <- neuroblastomaProcessed$feature.mat
Y <- neuroblastomaProcessed$target.mat

predict_accuracy(X, Y)


# Penalty Learning
data("penalty.learning")
X <- penalty.learning$X.mat
Y <- penalty.learning$y.mat
smp_size <- floor(0.75 * nrow(X))
set.seed(123)
train_ind <- sample(seq_len(nrow(X)), size = smp_size)
X_train <- X[train_ind,] 
X_test <- X[-train_ind,]
Y_train <- Y[train_ind,] 
Y_test <- Y[-train_ind,]

cv_fit <- cv.iregnet(X_train, Y_train, nfolds = 5L, family = "gaussian")
plot(cv_fit)
min.idx <- cv_fit$selected[1]
sd.idx <- cv_fit$selected[2]

fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[min.idx])
Y_predicted <- predict(fit, newx = X_test, type = "response")
correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
cat("Accuracy with min lambda:", (correct/nrow(Y_test))*100)
fit <- iregnet(X_train, Y_train, num_lambda = 1, lambda = cv_fit$lambda[sd.idx])
Y_predicted <- predict(fit, newx = X_test, type = "response")

correct <- sum(Y_predicted >= Y_test[,1] & Y_predicted <= Y_test[,2])
cat("Accuracy with lambda at 1sd:", (correct/nrow(Y_test))*100)
  


# Iregnet vs glmnet
fit_irg <- iregnet(X_train, Surv(Y_train[,1], Y_train[,2]))
result_irg <- predict(fit_irg, X_test)
fit_irg <-cv.iregnet(X_train, Surv(Y_train[,1], Y_train[,2]), family = "gaussian")





big.fit <- iregnet(x, Surv(y[,1], y[,2]), family="gaussian", unreg_sol=FALSE)
fit <- iregnet(
  x, Surv(y[,1], y[,2]),
  family="gaussian",
  lambda=big.fit$lambda,
  unreg_sol=FALSE)
pred.center.mat <- predict(fit, x)
pred.scale.mat <- matrix(
  fit$scale,
  nrow(pred.center.mat),
  ncol(pred.center.mat),
  byrow=TRUE)
cat(pred.center.mat)
loglik <- compute.loglik(y, pred.center.mat, pred.scale.mat, family=family)
