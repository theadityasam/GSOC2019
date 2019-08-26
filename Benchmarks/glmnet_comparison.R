set.seed(100)
n <- 100
x <- matrix(rnorm(n*20), n, 20)
y <- rnorm(n)

## Standardize variables: (need to use n instead of (n-1) as denominator)
mysd <- function(y) sqrt(sum((y-mean(y))^2)/length(y))
sx <- scale(x, scale = apply(x, 2, mysd))
sx <- as.matrix(sx, ncol = 20, nrow = 100)
sy <- as.vector(scale(y, scale = mysd(y)))

## Calculate lambda path (first get lambda_max):
lambda_max <- max(abs(colSums(sx*sy)))/n
epsilon <- .0001
K <- 100
lambdapath <- round(exp(seq(log(lambda_max), log(lambda_max*epsilon), 
                            length.out = K)), digits = 10)
lambdapath

## Compare with glmnet's lambda path:
fitGLM <- glmnet(sx, sy)
fitGLM$lambda
iregnet(sx, sy)


max( abs(t(Y - mean(Y)*(1-mean(Y))) %*% X ) )/ ( alpha * n) # largest lambda value
glmnet(x=X,y=Y,alpha = alpha,standardize=FALSE)$lambda[1]


x <- matrix(rnorm(50), nrow = 5, ncol = 10)
y <- rnorm(5)
Surv(x, event=matrix(rep(1, nrow(x))), nrow=6, ncol=1)
fit_irg <- iregnet(x, y)


data(ovarian)
str(ovarian[])
x <- cbind(ovarian$ecog.ps, ovarian$rx)

fit_s <- survreg(Surv(futime, fustat) ~ x, data = ovarian, dist = "gaussian")
fit_i <- iregnet(x, Surv(ovarian$futime, ovarian$fustat),
                 family="gaussian", alpha=1, intercept = T, threshold=1e-09)

