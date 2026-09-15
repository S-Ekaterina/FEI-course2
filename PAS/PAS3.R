# 12 zadanie
# Milióny turistov, ktorí navštívili Španielsko v rokoch 2003, 2004 a 2005 
# podľa ich národností sú uvedené v nasledujúcej tabuľke:
# (a) Uložte hodnoty v tejto tabuľke do matice s názvom tourists.
nationality <- c("G", "F", "B", "A", "R")
year <- c("2003", "2004", "2005")
tourists <- matrix(1:15, byrow = TRUE, nrow = 5)
tourists
dimnames(tourists) <- list(nationality, year)
tourists
# (b) Vypočítajte súčty riadkov.
# (c) Vypočítajte súčty stĺpcov.
apply(tourists, 1, sum)
apply(tourists, 2, sum)

# 13 problem
# Použite cyklus for na konverziu sekvencie teplôt (od 18 do 28 so skokom 2) z °C na °F.
for (celsius in seq(18,28,2)) {
  print(c(celsius, 9/5 * celsius + 32))
}

# 194 - 4
library(PASWR2)
quantile(WHEATUSA2004$acres)
quantile(WHEATUSA2004$acres, probs = seq(0.1,1.0,0.1))
mean(WHEATUSA2004$acres)
IQR(WHEATUSA2004$acres)
var(WHEATUSA2004$acres)
sd(WHEATUSA2004$acres)
sum(WHEATUSA2004$acres)

which(WHEATUSA2004[order(WHEATUSA2004$acres),]$states == "WI")
dim(WHEATUSA2004)
pk <- (9 - 1)/(30 - 1)
pk
quantile(WHEATUSA2004$acres, probs = pk)

p1 <- ggplot(data = WHEATUSA2004, aes(x = acres, y = ..density..)) + 
  geom_histogram() +
  theme_bw() +
  geom_density()
p1 + geom_vline(xintercept = c(median(WHEATUSA2004$acres), mean(WHEATUSA2004$acres))) +
  annotate("text", label = "Median", x = median(WHEATUSA2004$acres), y = 0.0012) +
  annotate("text", label = "Mean", x = mean(WHEATUSA2004$acres), y = 0.0010)

boxplot(WHEATUSA2004$acres, horizontal = TRUE)

outliers <- boxplot.stats(WHEATUSA2004$acres)$out
outliers
WHEATUSA2004[WHEATUSA2004$acres %in% outliers, ]

noKS <- WHEATUSA2004[WHEATUSA2004$states != "KS", ]
noKS

head(VIT2005)
VIT2005$out <- factor(VIT2005$out, levels = c("E25", "E50", "E75", "E100"))
levels(VIT2005$out)
xtabs(~out, data = VIT2005)
p1 <- ggplot(data = VIT2005, aes(x = factor(1), fill = out)) +
  geom_bar(width = 1) + 
  coord_polar(theta = "y")
p1
p2 <- ggplot(data = VIT2005, aes(x = out)) + geom_bar(width = 1)
p2
multiplot(p1,p2)

ggplot(data = VIT2005, aes(x = totalprice)) + 
  geom_histogram()
median(VIT2005$totalprice)
mean(VIT2005$totalprice)
IQR(VIT2005$totalprice)

ggplot(data = VIT2005, aes(x = area, y = totalprice, color = as.factor(toilets))) +
  geom_point() +
  facet_grid(toilets ~ .) +
  guides(colour = guide_legend("Number of toilets"))

both <- subset(VIT2005, subset = area >=80 & area <= 100)
# VIT2005[VIT2005$area >= 80 & VIT2005$area <= 100] ??
tapply(both$totalprice, both$toilets, median)
diff(tapply(both$totalprice, both$toilets, median))







  
  
  