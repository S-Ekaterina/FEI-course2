# NORSIM function
norsim <- function(sims = 100, n = 36, mu = 100, sigma = 18, 
                   conf.level = 0.95){
  alpha <- 1 - conf.level
  CL <- conf.level * 100
  ll <- numeric(sims)
  ul <- numeric(sims)
  for (i in 1:sims){
    xbar <- mean(rnorm(n , mu, sigma))
    ll[i] <- xbar - qnorm(1 - alpha/2)*sigma/sqrt(n)
    ul[i] <- xbar + qnorm(1 - alpha/2)*sigma/sqrt(n)
  }
  notin <- sum((ll > mu) + (ul < mu))
  percentage <- round((notin/sims) * 100, 2)
  SCL <- 100 - percentage
  WIDTH <-mean(ul-ll) 
  plot(ll, type = "n", ylim = c(50, 150), xlab = " ", 
       ylab = " ")
  for (i in 1:sims) {
    low <- ll[i]
    high <- ul[i]
    if (low < mu & high > mu) {
      segments(i, low, i, high)
    }
    else if (low > mu & high > mu) {
      segments(i, low, i, high, col = "red", lwd = 5)
    }
    else {
      segments(i, low, i, high, col = "blue", lwd = 5)
    }
  }
  abline(h = mu)
  cat(SCL, "\b% of the random confidence intervals contain Mu =", mu, "\b.", "\n")
  cat(WIDTH, "is the average length of confidence intervals", "\n")
}

#######################################################################
## ---- Question 1: Simulate 100 confidence intervals,
## for the mean, when n=36, population mean = 100,
## population st deviation = 18, and confidence level is 95%.
## Use norsim to get the confidence intervals and use random seed 10.
## What you observe? 
## ---- Question 1: Solution:
par(mfrow=c(1,1)) 
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)

#######################################################################
## ---- Question 2: Next, we investigate the effect of the random seed.
## Use the same setting as in question 1:
## n=36, population mean = 100, population st deviation = 18, 
## and confidence level is 95%.
## Compare two scenarios: random seed 10 vs 100.
## What is the effect of changing the random seed?  
## Solution:
par(mfrow=c(1,2)) 
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)
set.seed(100)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)
# Answer: now 97% of CI contain Mu=100, eventhough the CIs are 
# 95% intervals. The difference between 95 and 97 is due random chance.
# If instead of sims=100 i run sims=1 million, the random chance will 
# not play role anymore.

#######################################################################
## ---- Question 3: Next, we investigate the effect of n.
## Use the same setting as in question 1:
## population mean = 100, population st deviation = 18, 
## confidence level 95% and random seed 10.
## Compare two scenarios: n=36 vs n 144. 
## What is the effect of increasing n? 
## Solution:
par(mfrow=c(1,2))
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)
set.seed(10)
norsim(sims = 100, n = 144, mu = 100, sigma = 18, conf.level = 0.95)
# Answer: now 94% of CI contain Mu=100, eventhough the CIs are 
# 95% intervals. The difference between 94 and 95 is due random chance,
# i.e. due to the fact that we only simulation 100 CIs.
# We also observe that the confidence intervals get smaller, 
# this is due larger n. Since n is 144 which is 4 times larger than 36
# we have sqrt(4)=2 times narrower intervals.

#######################################################################
## ---- Question 4: Next, we investigate the effect of sigma.
## Use the same setting as in question 1:
## population mean = 100, sample size n = 36, 
## confidence level 95% and random seed 10.
## Compare two scenarios: sigma=18 vs 3*18  
## What is the effect of increasing sigma? 
## Solution:
par(mfrow=c(1,2))
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18*3, conf.level = 0.95)
# Answer: In both scenarios 95% CIs do contain the true value 100.
# We also observe that the confidence intervals are wider in the 
# second scenario, this is due larger sigma. Since in the second scenario,
# sigma is three times larger the intervals are three times wider.

#######################################################################
## ---- Question 5: Next, we investigate the effect of confidence.
## Use the same setting as in question 1:
## population mean = 100, sample size n = 36, 
## sigma = 18 and random seed 10.
## Compare two scenarios: significance=95% vs 99%.  
## What is the effect of increasing the confidence?
## Solution:
par(mfrow=c(1,2))
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.95)
set.seed(10)
norsim(sims = 100, n = 36, mu = 100, sigma = 18, conf.level = 0.99)
# Answer: Here the CIs differ but correspond to the inserted values.
# The higher confidence increases the average width of the confidence intervals,
# and the number of intervals that do not cover the mu value is smaller
# when used with higher confidence level.