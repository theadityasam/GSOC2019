# Summary of GSOC2019

* Organisation: R Project for Statistical Computing
* Project: IREGNET on CRAN
* Mentor: Anuj Khare <khareanuj18@gmail.com>, Toby Hocking <tdhock5@gmail.com>
* Student: Aditya Samantaray <aditya.samantaray1@gmail.com>
* Repo Link: https://github.com/anujkhare/iregnet

## Background
Interval regression is a class of machine learning models which is useful when the predicted values are real numbers but
the outputs in the training data might be censored i.e. they might not be real distinct value, rather an interval time period.
Possible examples are Survival Analysis, Reliability Analysis in engineering, Duration Analysis in economics, and 
Event History Analysis in sociology.

Iregnet is the first R package to perform interval regression with elasticnet regularization supporting four types of 
censorship - left, right, interval and none. It fits an **Accelerated Failure Time(AFT)** model on the input data.

## Related Coding Work
The source code of iregnet was written by Anuj Khare and the cross validation method was coded by Toby Hocking. The main goal
of this year's GSOC was to make sure the package gets published on CRAN. For that, the package needs to be tested and debugged
so that it passes all CRAN checks. 
Link of the project description: https://github.com/rstats-gsoc/gsoc2019/wiki/iregnet-on-CRAN#coding-project-iregnet-on-cran 
The work done for getting the package on CRAN has been briefly described below alongwith the links to the changes and additions.

### Merging PR#54
Link: https://github.com/anujkhare/iregnet/pull/54 

The first task was to make sure that the cross validation method is reviewed and implemented. Changes were made to the code 
so that the builds pass for [cv.iregnet.R](https://github.com/anujkhare/iregnet/blob/master/R/cv.iregnet.R) i.e. the K-fold
CV method should work as expected. Also, as per the Toby's recommendations, future.apply has been implemented over foreach 
([link](https://github.com/anujkhare/iregnet/issues/69)).

### Testing the package on several datasets

The package needed to be tested on all kinds of dataset. Tests have been written which fit `iregnet` on [ovarian](https://github.com/anujkhare/iregnet/blob/master/tests/testthat/test_survival_glmnet.R), [prostate](https://github.com/anujkhare/iregnet/blob/master/tests/testthat/test_elemStatsLearn.R), 
[neuroblastomaProcessed](https://github.com/anujkhare/iregnet/blob/master/tests/testthat/test_all_open.R#L50), [penalty.learning](https://github.com/anujkhare/iregnet/blob/master/tests/testthat/test_cv.R#L6) datasets.
Link to benchmark: https://theadityasam.github.io/iregbenchmark/benchmarks.html

Toby had also provided a code that would test `iregnet` on 33 datasets.
Link: https://github.com/anujkhare/iregnet/issues/71
The issue prevailed in the old code where the default value of threshold was 1e-4. On almost all the datasets, it
was fixed when the default threshold was set to 1e-3. This problem was witnessed in the datasets where the 
number of predictors > number of observations. Some predictors failed to converge and reached max iterations, resulting in a jump 
in runtimes. For this case, sequential strong rules ([link](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262615/)) as well as stronger regularization parameter is required.
Further work needed to be done to implement those features but unfortunately, I couldn't do it during the coding period as I was in 
a learning phase and had to test and fix other issues. Nevertheless I'll keep on working to implement them even after the coding period ends.

### A detailed vignette 
Link: https://theadityasam.github.io/iregvignette/iregnet.html

A very detailed vignette has been written for the package. The vignette covers everything, package installation, dataset 
examples (left censored, right censored, interval censored and uncensored), predictions, hyperparameter tuning for lambda selections
and the theory & algorithms implemented. The vignette includes speed comparisions with `survival` and `glmnet` package as well as
accuracy comparisions with `IntervalRegressionCV` from `penaltyLearning` package.

### Making sure the docs and tests pass the CRAN checks
Link: https://travis-ci.org/anujkhare/iregnet

To test if the package is ready for CRAN submission, we run `R CMD check --as-cran` to check for any potential build errors.
The travis builds of the master branch produce no errors and hence the package is good to go for submission.

## Summary of goals accomplished

Iregnet is now feature complete, with cross validation function implemented, complete documentation, passing build tests and 
a detailed vignette explaining its functionalities. The package has been posted on CRAN and will soon be available for installation using:
```
install.packages("iregnet")
```


## Potential Future Work

1) Implementation of sequential strong rules ([link](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4262615/)). A potential reason for
the sheer speed of glmnet's convergence might be the rules implemented into the algorithm that discard the predictors that are
estimated to not affect the fit significantly.

2) Also, glmnet has early stoppage along the lambda path. The algorithm stops when the change in deviance is below the threshold.
Since any model selection method(such as K-fold CV) will select a generously regularised model, there is no point in continuing
till the end of lambda path(end of the lambda path is an unregularised solution).

3) During the testing, we did encounter some issues which affect the speed and the convergence of the package.
* The algorithm fails to converge on some datasets(mostly observed when no. of predictors > no. of observations). This can be 
potentially reduced by introducing the sequential strong rules so that the number of predictors can be reduced.
* The log of scale is required for scale update. In some cases, the scale becomes negative(needs to be debugged ASAP) turning the
log(scale) to NaN and hence the subsequent fits become NaNs. 

I plan on working on fixing these issues even after the coding period is over. I was unable to do it during the coding period 
as it took time for me to get used to the intricacies of the package. It was a huge learning experience for me as now 
I'm confident over my grasp of the R language and will be able to work on it effortlessly.

