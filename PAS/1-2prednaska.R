# 1 prednaska
options(width= 70) # širka konzoly (70 symbolov)
set.seed(12) # pomäta nahodne čisla
ruv <- runif(n= 20, min= 0, max= 1) # 20 nahodnych čisiel od 0 do 1
round(ruv, 4) # zaokruglovanie až na 4 znaky  po ,
set.seed(12) # tie iste čisla
ruv <- runif(n= 20, min= 0, max= 1)
round(ruv, 4) 
set.seed(4000) # nove čisla
ruv <- runif(n= 20, min= 0, max= 1)
round(ruv, 4) 

(7 * 3) + 12/2 - 7^2 + sqrt(4)

# vektor
x <- 5 # vector of length 1
y <- c(7, 3, 5) # vektor into y
z <- c(2, 4, 6, 8) # vektor into z
x + y
c(5, 5, 5) + y # the shorter vector is recycled 3 times
y + z # = warning, length(y) musia byt = length(z)
c(y, 7) + z # teraz uz length(y) = length(z)

str(x)
str(y)
str(z)
w <- c('Iam' ,100,'%correc')
w
str(w)

# NaN, −Inf and Inf
NV<- c(-4, 0, 2, 4, 6)
NV/NV # 0/0 is not a number (NaN)
sqrt(NV) # cannot take square root of −4
NV^9999 # very large and small numbers use −Inf and Inf

# mode a class
Num<-c(1,pi ,5)
Log<-c(TRUE,FALSE,TRUE)
Chr<-c('a','character','vector')
mode(Num)
class(Num)
mode(Log)
class(Log)
mode(Chr)
class(Chr)

x2 <- 1:5 # c(1,2,3,4,5)
Y2 <- x2+rnorm(n=5,mean=0,sd=0.5) #add normal errors
model<-lm(Y2~x2) #Regressing Y2 onto x2
mode(model) #model has mode list
class(model) #model has class lm
Y2

help.start()
example(median)
median(c(100,1000))

my.dnorm<-dnorm(c(-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7),0,2)
plot(c(-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7),
      my.dnorm,type='l',xlab='X',ylab='Probability_density_function',
      main='Normal_distribution, _mean_0, _sd_2')
my.seq<-seq(-7,7,by=0.1)
my.seq

my.dnorm<-dnorm(my.seq,mean=0,sd=2)
plot(my.seq,my.dnorm,type='l',xlab='X',ylab='Probability_density_function',
      main='Normal_distribution_with_mean_0_and_sd_2')

# 2 prednaska
Grades <- c('A' , 'D' , 'C' , 'D' , 'C' , 'C', 'C', 'C','F', 'B')
Grades
table(Grades)
xtabs (~Grades)
table(Grades)/length(Grades) # počet А,B,C,D,F vo vzťahu k počtu premennych
# or
prop.table(table(Grades)) # počet А,B,C,D,F vo vzťahu k počtu premennych
barplot(xtabs (~Grades), col = 'gray40' , xlab = 'Grades' ,
        ylab = 'Frequency')

# Example 2.2
library(MASS)
table(quine$Age) # =
with(data=quine , table(Age)) # =
xtabs(~Age,data=quine)

example("barplot")
barplot(xtabs(~Age,data=quine), col = 'gray90' , xlab = 'Age' ,
        ylab = 'Frequency')

Grades <- c('A' , 'D' , 'C' , 'D' , 'C' , 'C', 'C', 'C','F', 'B')
opar <- par(no.readonly = TRUE) # read in current parameters
par(mfrow=c(2 , 2)) # change parameters of the plotting
barplot(xtabs (~Grades), col = 'gray40' , xlab = 'Grades',
        ylab = 'Frequency')

# zadanie 2.7
library(PASWR2)
head(BABERUTH)
NYYY <- BABERUTH[BABERUTH$team == 'NY-A', ]
NYYY
NYYHR <- BABERUTH$hr[BABERUTH$team == 'NY-A']
NYYHR
stem(NYYHR)
rm(NYYHR)

# zadanie 2.9
opar <- par(no.readonly = TRUE) # uloži aktualne parametre grafickeho zariadenia
par(mfrow=c(1 , 2))
# rozdeli graficke okienko na 1 riadok a 2 stlpca
bin <- seq(20, 70, 10)
# vytvara postupnosť čisiel od 20 do 70 s krokom 10
hist(BABERUTH$hr [7:21], breaks = bin, xlab = 'Home_Runs' , col = 'pink',
     main = 'Bins_of_form_(_]')
hist(BABERUTH$hr [7:21] , breaks = bin , right = FALSE, xlab = 'Home_Runs' ,
     col = 'pink' , main = 'Bins_of_form_[_)')
par(opar) # vratim sa k počiatočnym parametrom

library(PASWR2)
BABERUTH
NYYHR <- BABERUTH$hr[7:21]
NYYHR
mean(NYYHR)
