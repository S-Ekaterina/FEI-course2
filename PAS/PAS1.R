# number 1
(7-8)+5^3-5/6+sqrt(62)
log(3)+sqrt(2)*sin(pi)-exp(3)
2*(5+3)-sqrt(6)+9^2
log(5)-exp(2)+2^3
9/2*4-sqrt(10)+log(6)-exp(1)
# number 2
countby5 <- seq(5,100,5)
print(countby5)
# number 3
Treatment <- c(rep("Treatment One", 20), rep('Treatment Two', 18), rep("Treatment Three", 22)) 
print(Treatment)
# number 4
rep(seq(20,5,-5), 1:4)
# number 5
#a
x <- 5
y <- 7
z <- x^y
print(z)
#b
u <- c(1,2,3,4)
v <- c(2,2,1,1)
print(u)
print(v)
#c
u <- c(1,2,3,4,8,6,7,5,9)
how <- which(u == 5)
print(how)
#d
v <- c(1,2,3,4,8,6,7,5,9)
how <- which(v >= 2)
print(how)
#e
k <- u*v
print(k)
#f
u <- c(4,5,9)
v <- c(4,7,3)
u*c(u,v)
#g
G <- seq(1,10)
first <- head(1:3)
print(first)
#i
q <- c(3,0,1,6)
r <- c(1,0,2,4)
sum(q*r)
#j
u <- c(1,2,3,4)
v <- c(2,2,1,1)
X <- rbind(u,v)
print(X)
#k
Y <- cbind(u,v)
print(Y)
#l
W <- X %*% Y
print(W)
#m
t(W)
solve(W)
# number 6
library(PASWR2)
#data(package="PASWR2")
head(VIT2005)
sum(VIT2005$totalprice > 400000 & VIT2005$garage == 1)
# number 7
wheatspain <- data.frame(
  community = c("Galicia", "Asturias", "Cantabria", "Pais Vasco", "Navarra", "La Rioja", "Aragon", "Cataluna", "Islas Baleares", "Castilla y Leon", "Madrid", "Castilla-La Mancha", "C. Valenciana", "Region de Murcia", "Extremadura", "Andalucia", "Islas Canarias"),
  wheat.surface = c(18817, 65, 440, 25143, 66326, 34214, 311479, 74206, 7203, 619858, 13118, 263424, 6111, 9500, 143250, 558292, 100)
)
#a
print(wheatspain)
#b
max(wheatspain$wheat.surface)
min(wheatspain$wheat.surface)
#c
wheatspain$community[which.max(wheatspain$wheat.surface)]
#d
wheatspain[order(wheatspain$wheat.surface), ]
#e
wheatspain[order(-wheatspain$wheat.surface), ]
#f
# 2 problem
library(MASS)
library(ggplot2)
library(lattice)
help(package="MASS")
search()

min(Cars93$Min.Price)
p1 <- ggplot(data = Cars93, aes(x=Min.Price, y = ..density..)) + 
  geom_histogram(fill = "red", binwidth = 5) +
  geom_density(size=1, color="darkred") +
  theme_bw()

p2 <- ggplot(data = Cars93, aes(x=Max.Price, y = ..density..)) + 
  geom_histogram(fill = "green", binwidth = 5) +
  geom_density(size=1, color="darkgreen") +
  theme_bw()

p3 <- ggplot(data = Cars93, aes(x=Weight, y = ..density..)) + 
  geom_histogram(fill = "blue", binwidth = 5) +
  geom_density(size=1, color="darkblue") +
  theme_bw()

p4 <- ggplot(data = Cars93, aes(x=Length, y = ..density..)) + 
  geom_histogram(fill = "yellow", binwidth = 5) +
  geom_density(size=1, color="orange") +
  theme_bw()

multiplot(p1,p2,p3,p4,layout = matrix(c(1,2,3,4), byrow = TRUE, nrow = 2))
par(mfrow=c(1,1))

boxplot(Cars93$Min.Price, data=Cars93)
bwplot(Price ~ DriveTrain | Type, data = Cars93, as.table=TRUE)

ggplot(data=Cars93, aes(x=DriveTrain, y=Price)) +
  geom_boxplot() +
  facet_wrap(~ Type) +
  theme_bw()

# 3 zadanie
data("WHEATSPAIN")
#a
describe <- function(x, ...) {
  quantiles <- quantile(x)
  print(c("Quantiles" = quantiles))
}
describe(WHEATSPAIN$hectares)

bottom10 <- quantile(WHEATSPAIN$hectares, probs = 0,1)
WHEATSPAIN[WHEATSPAIN$hectares < bottom10, ]
WHEATSPAIN[order(WHEATSPAIN$hectares), ]
which(WHEATSPAIN[order(WHEATSPAIN$hectares), ]$community == "Navarra")
quantile(WHEATSPAIN$hectares, probs = (11-1)/(17-1))
#e
# page 193



