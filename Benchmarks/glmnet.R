library(glmnet)
library(iregnet)
library(dplyr)
library(microbenchmark)
library(ggplot2)
library(directlabels)

data("Prostate", package = "lasso2")
X = as.matrix(Prostate[, c(2:9)])
Y = matrix(c(Prostate[, 1],Prostate[, 1]), nrow = nrow(Prostate), ncol = 2)
colnames(Y)[c(1,2)] <- "lcalvol"
res <- data.frame() #Result data frame

fit_irg <- iregnet(X, Y)
fit_glm <- glmnet(X,Y[,1])
sx <- as.matrix(scale(X))
sy <- as.vector(scale(Y))
max(abs(colSums(sx*sy)))/100

mysd <- function(Y) sqrt(sum((Y-mean(Y))^2)/length(Y))
sx <- scale(X,scale=apply(X, 2, mysd))
sx <- as.matrix(sx, ncol=20, nrow=100)
sy <- as.vector(scale(Y[,1], scale=mysd(Y[,1])))
max(abs(colSums(sx*sy)))/100


for(i in c(4:(nrow(X)/5))*5)
{
  evaltime <- microbenchmark(iregnet(X[1:i,], Y[1:i,]), 
                             iregnetoptim(X[1:i,], Y[1:i,]), 
                             glmnet(X[1:i,], Y[1:i,1]), 
                             times = 100L)
  res <- bind_rows(res, data.frame(i, list(summary(evaltime)[,c('lq','mean','uq')])))
}
res <- cbind.data.frame(c("IREGNET", "Iregnet Optimization", "GLMNET"), res)
names(res) <- c("expr", names(res)[2:5])
p <- ggplot(res, aes(x = i))+
  geom_ribbon(aes(ymin = lq, ymax = uq, fill = expr, group = expr), alpha = 1/2)+
  geom_line(aes(y = mean, group = expr, colour = expr))+
  ggtitle('Runtime(in milliseconds) vs Dataset Size') +
  xlab('Dataset Size') +
  ylab('Runtime (in milliseconds)')
direct.label(p,"angled.boxes")


deviance <- function(X, Y){
  glmnet.control(fdev = 0)
  fit <- glmnet(X[1:i,], Y[1:i,1])
}


## Randomly generated data with deviance control
X <- rnorm(5000000, 1, 1.5) %>% matrix(nrow = 100000, ncol = 5)
Y <- rnorm(1000000, 1, 1.5) %>% matrix(nrow = 100000, ncol = 1)
Y = matrix(c(Y, Y), nrow = 100000, ncol = 2)
res <- data.frame() 
for(i in 10^(seq(2, 5)))
{
  evaltime <- microbenchmark( #iregnet(X[1:i,], Y[1:i,]), 
                             #iregnetoptim(X[1:i,], Y[1:i,]), 
                              glmnet(X[1:i,], Y[1:i,1]),
                              deviance(X, Y),
                              times = 100L)
  res <- bind_rows(res, data.frame(i, list(summary(evaltime)[,c('lq','mean','uq')])))
}
res <- cbind.data.frame(c("IREGNET", "Iregnet Optimization", "GLMNET"), res)
res <- cbind.data.frame(c("IREGNET", "Glmnet", "GlmnetDev"), res)
res <- cbind.data.frame(c("Glmnet", "GlmnetDev"), res)

names(res) <- c("expr", names(res)[2:5])
p <- ggplot(res, aes(x = i))+
  geom_ribbon(aes(ymin = lq, ymax = uq, fill = expr, group = expr), alpha = 1/2)+
  geom_line(aes(y = mean, group = expr, colour = expr))+
  ggtitle('Runtime(in milliseconds) vs Dataset Size') +
  xlab('Dataset Size') +
  ylab('Runtime (in milliseconds)')
direct.label(p,"angled.boxes")
