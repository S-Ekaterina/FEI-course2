# Salova Ekaterina
# p_14_a_salova

# 1 zadanie
pos <- 1 - ppois(2, 7)
round(pos,3)

# 2 zadanie
set.seed(999)
zad <- replicate(10000, mean(rbinom(1000, 1, 0.4)))
mean(zad)
sd(zad)

# 3 zadanie
toy <- pbinom(18,20,0.88) - pbinom(15,20,0.88)
round(toy,3)

# 4 zadanie
# N(90,15) and N(100,10)
var <- 15^2 + 10^2
el <- 1 - pnorm(0, -10, sqrt(var))
round(el, 3)

# 5 zadanie
choose(5,3)
5^3

# 6 zadanie
cov <- 11200 - 70*160
cov

# 7 zadanie
# N(40,4) N(40,4) N(110,10)
var <- 4^2 + 4^2 + 10^2
chocolate <- pnorm(200, 190, sqrt(var), lower.tail = FALSE)
round(chocolate, 3)

# 8 zadanie
vitamin <- pnorm(0.65, 0.66, 0.017)
round(vitamin, 3)

# 9 zadanie
0.2 / sqrt(400) 

# 10 zadanie
var <- 10*0.5
h <- ppois(4, var)
round(h, 3)