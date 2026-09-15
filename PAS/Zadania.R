# 1.21.1
# Vypočítajte nasledujúce číselné výsledky na tri desatinné miesta s R:
(7-8) + 5^3 - 5/6 + sqrt(62)
log(3) + sqrt(2)*sin(pi) - exp(3)
2 * (5+3) - sqrt(6) + 9^2
log(5) - exp(2) + 2^3
(9/2)*4 - sqrt(10) + log(6) - exp(1)
# 1.21.2
# Vytvorte vektor s názvom count by 5, ktorý je sekvenciou 5 až 100 v krokoch po 5.
countby5 <- seq(5,100,5)
print(countby5)
# 1.21.3
# Vytvorte vektor Treatment, ktorý bude obsahovať "Treatment One" 20-krát, "Treatment Two" 18-krát a "Treatment Three" 22-krát
Treatment <- c(rep("Treatment One", 20), rep('Treatment Two', 18), rep("Treatment Three", 22)) 
print(Treatment)
xtabs(~Treatment)
# 1.21.4
# Doplnte chýbajúce hodnoty v rep(seq( , , ), ), aby vznikla sekvencia 20, 15, 15, 10, 10, 10, 5, 5, 5, 5.
rep(seq( 20, 5, -5), 1:4)
# 1.21.5
# Priraďte hodnoty 5 a 7 do premenných x a y a vypočítajte hodnotu xy, ktorá sa uloží do premennej z. Aká je hodnota v premennej z?
x <- 5
y <- 7
z <- x*y
# Vytvorte vektory u = (1, 2, 5, 4) a v = (2, 2, 1, 1) pomocou funkcie c().
u <- c(1, 2, 5, 4)
v <- c(2, 2, 1, 1)
# Zistite, ktorá zložka vektora u je rovná 5.
which(u == 5)
# Zistite, ktoré zložky vektora v sú väčšie alebo rovné 2.
which(v >= 2)
# Vypočítajte súčin vektorov u a v. Ako R vykonáva túto operáciu?
u*v
# Vysvetlite, čo R robí, keď sú dva vektory rôznej dĺžky vynásobené. Konkrétne, čo sa stane pri u * c(u, v)?
u * c(u,v)
# Vytvorte sekvenciu od 1 do 10 nazvanú G a následne vyberte prvé tri komponenty z G.
G <- seq(1,10)
G[1:3]
# Vytvorte sekvenciu od 1 do 30 s krokom 2 nazvanú J a následne vyberte prvú, tretiu a ôsmu hodnotu zo J.
J <- seq(1,30,2)
J[c(1,3,8)]
# Vypočítajte skalárny súčin (dot produkt) vektorov q = (3, 0, 1, 6) a r = (1, 0, 2, 4).
q <- c(3, 0, 1, 6)
r <- c(1, 0, 2, 4)
sum(q*r)
q %*% r
# Definujte maticu X, ktorá má riadky z vektorov u a v z predchádzajúceho bodu.
X <- rbind(u, v)
X
# Definujte maticu Y, ktorá má stĺpce z vektorov u a v z predchádzajúceho bodu.
Y <- cbind(u, v)
Y
# Vypočítajte maticový súčin matíc X a Y a uložte ho do premennej W.
W <- X%*%Y
W
# Poskytnite kód, ktorý vypočíta inverznú maticu k W a transponovanú inverznú maticu.
solve(W)
t(solve(W))
# 1.21.6
# Koľko apartmánov v dátovom rámci VIT2005 (časť balíka PASWR2) má celkovú cenu vyššiu ako 400 000 a zároveň má garáž? 
# Použite jednu riadkovú R kód na zistenie odpovede.
library(PASWR2)
sum(VIT2005$totalprice > 400000 & VIT2005$garage == "Yes")
dim(VIT2005[VIT2005$totalprice >=400000 & VIT2005$garage >=1, ])[1]
# 1.21.7
# Pšenica zberaná na povrchu v Španielsku v roku 2004: Poskytnite R kód na zodpovedanie všetkých otázok týkajúcich sa 
# zberu pšenice v rôznych autonómnych komunitách v Španielsku.

# Vytvorte premenné community a wheat.surface z tabuľky pšenice a uložte ich do dátového rámca wheatspain
community <- c("Galicia", "Asturias", "Cantabria", "País Vasco", "Navarra", "La Rioja", "Aragón", "Cataluña", "Islas Baleares", 
               "Islas Canarias", "Andalucía", "Castilla-La Mancha", "Castilla y León", "Madrid", "C. Valenciana", "Región de Murcia", "Extremadura")
wheat.surface <- c(18817, 65, 440, 25143, 66326, 34214, 311479, 74206, 7203, 100, 558292, 263424, 619858, 13118, 6111, 9500, 143250)
wheatspain <- data.frame(community, wheat.surface)
rm(community, wheat.surface)
head(wheatspain)
# Nájdite maximálnu, minimálnu hodnotu a rozsah pre premennú wheat.surface.
max(wheatspain$wheat.surface)
min(wheatspain$wheat.surface)
max(wheatspain$wheat.surface) - min(wheatspain$wheat.surface)
diff(range(wheat.spain$wheat.surface))
# Ktorá komunita má najväčšiu zberanú plochu pšenice?
wheatspain$community[which.max(wheatspain$wheat.surface)]
wheatspain[wheatspain$wheat.surface == max(wheatspain$wheat.surface),]
# Zoradte autonómne komunity podľa plochy zberu pšenice v rastúcom poradí.
wheatspain[order(wheatspain$wheat.surface),]
# Zoradte autonómne komunity podľa plochy zberu pšenice v klesajúcom poradí.
wheatspain[order(-wheatspain$wheat.surface),]
# Vytvorte nový súbor s názvom wheat.c, kde bude Asturias odstránená.
wheat.c <- wheatspain[wheatspain$community != "Asturias",]
head(wheat.c)
# Pridajte Asturias späť do súboru wheat.c.
wheat.c <- rbind(wheat.c, wheatspain[wheatspain$community == "Asturias",])
wheat.c
# Vytvorte v wheat.c nový premenný acre, ktorý bude predstavovať zberanú plochu v akroch (1 akr = 0.40468564224 hektára).
wheat.c$acre <- wheat.c$wheat.surface / 0.40468564224
# Aký je celkový zber pšenice v hektároch a akroch v Španielsku v roku 2004?
sum(wheat.c$wheat.surface)
sum(wheat.c$acre)
# Definujte v wheat.c riadky pomocou názvov komunít a odstráňte premennú community.
row.names(wheat.c) <- wheat.c$community
wheat.c$community <- NULL
# Aké percento autonómnych komunít má zberanú plochu pšenice väčšiu ako priemerná plocha pšenice?
mean_surface <- mean(wheat.c$wheat.surface > mean(wheat.c$wheat.surface))*100
mean_surface
# Zoradte wheat.c podľa názvov autonómnych komunít (riadky).
wheat.c <- wheat.c[order(row.names(wheat.c)),]
# Zistite, ktoré komunity majú menej ako 40 000 akrov zberanej plochy a zistite ich celkovú plochu v hektároch a akroch.
lessthan40k <- wheat.c[wheat.c$acre < 40000,]
lessthan40k
apply(lessthan40k, 2, sum)
# Vytvorte nový súbor wheat.sum, kde sa autonómne komunity s plochou zberu pšenice menej ako 40 000 akrov 
# skonsolidujú do jednej kategórie s názvom "less than 40,000".
wheat.sum <- wheat.c
wheat.sum$community[wheat.sum$acre < 40000] <- "less than 40,000"

lt40 <- apply(lessthan40k, 2, sum)
gt40 <- wheat.c[wheat.c$acre >= 40000, ]
wheat.sum <- rbind(gt40, lt40)
row.names(wheat.sum)[11] <- c("less than 40,000")
wheat.sum
# Použite funkciu dump() na wheat.c a uložte výsledky do súboru wheat.txt. Odstráňte wheat.c zo svojej cesty a overte, 
# že ho môžete obnoviť zo súboru wheat.txt.
dump("wheat.c", file = "wheat.txt")
rm(wheat.c)
source("wheat.txt")
# Vytvorte textový súbor wheat.dat zo súboru wheat.sum pomocou príkazu write.table(). Vysvetlite rozdiely medzi wheat.txt a wheat.dat.
write.table(wheat.sum, file = "wheat.dat", row.names = FALSE)
# Použite príkaz read.table() na načítanie súboru wheat.dat.
wheat.dat <- read.table("wheat.dat", header = TRUE)
wheat.dat

# 1.21.8
site <- "http://www.stat.berkeley.edu/users/statlabs/data/babies.data"
BABIES <- read.table(file = url(site), header = TRUE)
summary(BABIES)
BABIES <- read.table("http://www.stat.berkeley.edu/users/statlabs/data/babies.data", header = TRUE)
# Premenné bwt, gestation, parity, age, height, weight, a smoke používajú hodnoty 999, 999, 9, 99, 99, 999, a 9 na označenie "neznáme". 
# V R sa na označenie chýbajúcich hodnôt používa NA. Rekódujte chýbajúce hodnoty v dátach BABIES. Náznak: 
# použite niečo podobné BABIES$bwt[BABIES$bwt == 999] = NA.
dim(BABIES)
BABIES$bwt[BABIES$bwt == 999] = NA
BABIES$gestation[BABIES$gestation == 999] = NA
BABIES$parity[BABIES$parity == 9] = NA
BABIES$age[BABIES$age == 99] = NA
BABIES$height[BABIES$height == 99] = NA
BABIES$weight[BABIES$weight == 999] = NA
BABIES$smoke[BABIES$smoke == 9] = NA
summary(BABIES)
# Použite funkciu na.omit() na vytvorenie "čistého" dátového súboru, ktorý odstráni subjekty, ak majú akúkoľvek neznámu hodnotu. 
# Uložte upravený dátový rámec do dátového rámca menom CLEAN.
CLEAN <- na.omit(BABIES)
dim(CLEAN)
# Zistite, koľko chýbajúcich hodnôt je pre premenné gestation, age, height, weight, a smoke, respektíve. 
# Koľko riadkov v BABIES nemá žiadne chýbajúce hodnoty, jedno chýbajúce, dve chýbajúce a tri chýbajúce hodnoty? 
# Počet riadkov v CLEAN by mal zodpovedať počtu riadkov v BABIES, ktoré nemajú chýbajúce hodnoty.
sum(is.na(BABIES$gestation))
sum(is.na(BABIES$age))
sum(is.na(BABIES$height))
sum(is.na(BABIES$weight))
sum(is.na(BABIES$smoke))
table(apply(is.na(BABIES), 1, sum))
# Použite funkciu complete.cases() na vytvorenie "čistého" dátového súboru, ktorý odstráni subjekty, ak majú akúkoľvek neznámu hodnotu. 
# Uložte upravený dátový rámec do dátového rámca menom CLEAN2. Napíšte riadok kódu, ktorý zobrazuje, 
# že všetky hodnoty v CLEAN sú rovnaké ako v CLEAN2.
CLEAN <- na.omit(BABIES)
CLEAN2 <- BABIES[complete.cases(BABIES), ]
sum(CLEAN != CLEAN2)
identical(CLEAN, CLEAN2)
# Triedte hodnoty v CLEAN podľa bwt, gestation a age. Uložte zoradené hodnoty do dátového rámca menom BGA a zobrazte posledných šest riadkov.
BGA <- CLEAN[order(CLEAN$bwt, CLEAN$gestation, CLEAN$age), ]
tail(BGA, 6)
# Uložte dátový rámec CLEAN do vášho pracovného adresára ako súbor .csv.
write.csv(CLEAN, "CLEAN.csv")
# Koľko percent žien v CLEAN je tehotných so svojím prvým dieťaťom (parity = 0) a nefajčia?
mean(CLEAN$parity==0 & CLEAN$smoke==0)*100

# 1.21.9 Práca s dátami WHEATUSA2004
# obsahuje údaje o plochách zberu pšenice v USA v roku 2004 podľa štátov. Má dve premenné: 
# states pre názov štátu a acres pre počet akrov.
library(PASWR2)
# Použite funkciu row.names() na definovanie štátov ako názvov riadkov pre dátový rámec WHEATUSA2004.
row.names(WHEATUSA2004) <- WHEATUSA2004$states
# Definujte novú premennú nazvanú ha pre plochu v hektároch, kde 1 akr = 0.40468564224 hektára.
WHEATUSA2004$ha <- WHEATUSA2004$acres*0.40468564224
# Triedte dáta podľa plochy zberu pšenice v akroch.
WHEATUSA2004[order(WHEATUSA2004$acres),]
# Ktoré štáty patria do top 10% štátov pre zber pšenice podľa plochy?
q <- quantile(WHEATUSA2004$acres, 0.9)
WHEATUSA2004[WHEATUSA2004$acres >= q, ]
# Uložte obsah WHEATUSA2004 do nového súboru s názvom WHEATUSA.txt v obľúbenom adresári. 
# Potom odstráňte WHEATUSA2004 zo svojho pracovného priestoru a skontrolujte, že 
# obsah WHEATUSA2004 môže byť obnovený zo súboru WHEATUSA.txt.
write.table(WHEATUSA2004, "WHEATUSA.txt")
rm(WHEATUSA2004)
WHEATUSA2004_recovered <- read.table("WHEATUSA.txt", header = TRUE)
# Použite príkaz write.table() na uloženie obsahu WHEATUSA2004 do súboru s názvom WHEATUSA.dat. 
# Vysvetlite rozdiely medzi uložením WHEATUSA2004 pomocou dump() a pomocou write.table().
write.table(WHEATUSA2004, "WHEATUSA.dat")
dump(WHEATUSA2004, "WHEATUSA.dat")
# Zistite celkovú plochu v akroch pre spodných 10% štátov podľa plochy.
q <- quantile(WHEATUSA2004$acres, 0.1)
bottom_10_percent <- WHEATUSA2004[WHEATUSA2004$acres <= q, ]
sum(bottom_10_percent$acres)

# 1.21.10
# Použite dátový rámec VIT2005 z balíka PASWR2, ktorý obsahuje údaje o 218 použitých bytoch predaných v 
# meste Vitoria (Španielsko) v roku 2005.
library(PASWR2)
# Vytvorte tabuľku počtu bytov podľa počtu garáží.
table(VIT2005$garage)
# Zistite priemernú cenu celkovú (totalprice) podľa počtu garáží.
mean()



# -------------------------------------------------------------
# 2 cvicenie
# 2.10
# 1
# Načítajte balík MASS.
# Zadajte príkaz help(package="MASS") a prečítajte si o funkciách a dátach obsiahnutých v tomto balíku.
# Čo hovorí popis v pomocnom súbore o funkcii lqs()? Zadajte príkaz help(lqs, package="MASS"), aby ste získali informácie o príkaze lqs.
# Aký príkaz zobrazí načítané balíky?
library(MASS)
# help(package = "MASS")
library(ggplot2) 
library(gridExtra) 
library(lattice)
# 2
# Vytvorte hustotné histogramy pre premenné Min.Price, Max.Price, Weight a Length, pričom pre každý histogram použite inú farbu.
# Na histogramy pridajte odhadované hustotné krivky.
p1 <- ggplot(data = Cars93, aes(x=Min.Price, y = ..density..)) + 
  geom_histogram(fill = "red", binwidth = 5) +
  geom_density(size = 1, color="darkred") +
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
grid.arrange(p1, p2, p3, p4, nrow = 2)
# (c) Ktoré autonómne komunity majú hodnotu hectares pod 10. percentilom? Ktoré sú nad 90. percentilom? 
# V ktorom percentile sa nachádza Navarra?
bwplot(Price ~ DriveTrain | Type, data = Cars93, as.table=TRUE)
# (d) Vytvorte a zobrazte v tom istom grafickom okne frekvenčný histogram a hustotný histogram pre premennú acres. 
# Na druhý histogram pridajte hustotnú krivku.
ggplot(data=Cars93, aes(x=DriveTrain, y=Price)) +
  geom_boxplot() +
  facet_wrap(~ Type) +
  theme_bw()

# 3 zadanie
# Načítajte dataset WHEATSPAIN z balíka PASWR2
library(PASWR2)
# (a) Nájdite kvantily, decily, priemer, maximum, minimum, interkvartilové rozpätie, 
# varianciu a štandardnú odchýlku pre premennú hectares. Okomentujte výsledky. 
# Aká bola celková plocha zberu pšenice v Španielsku v roku 2004 (v hektároch)?
quantile(WHEATSPAIN$hectares)
quantile(WHEATSPAIN$hectares, probs = seq(0.1,1.0,0.1))
mean(WHEATSPAIN$hectares)
IQR(WHEATSPAIN$hectares)
max(WHEATSPAIN$hectares)
min(WHEATSPAIN$hectares)
var(WHEATSPAIN$hectares)
sd(WHEATSPAIN$hectares)
sum(WHEATSPAIN$hectares)
# (b) Vytvorte funkciu, ktorá vypočíta kvantily, priemer, varianciu, štandardnú odchýlku, 
# celkovú hodnotu a rozpätie pre ľubovoľnú premennú.
describe <- function(x, ...) {
  quantiles <- quantile(x)
  Mean <- mean(x)
  Var <- var(x)
  Sd <- sd(x)
  Sum <- sum(x)
  Range <- diff(range(x))
  print(c(Quantiles = quantiles, Mean = Mean, Var = Var,
          SD = Sd, Total = Sum, Range = Range))
}
describe(WHEATSPAIN$hectares)
# (c) Ktoré autonómne komunity majú hodnotu hectares pod 10. percentilom? 
# Ktoré sú nad 90. percentilom? V ktorom percentile sa nachádza Navarra?
bottom10 <- quantile(WHEATSPAIN$hectares, probs = 0.1)
bottom10
WHEATSPAIN[WHEATSPAIN$hectares < bottom10, ]
top10 <- quantile(WHEATSPAIN$hectares, probs = 0.9)
top10
WHEATSPAIN[WHEATSPAIN$hectares > top10, ]
WHEATSPAIN[order(WHEATSPAIN$hectares), ]
which(WHEATSPAIN[order(WHEATSPAIN$hectares), ]$community == "Navarra")
quantile(WHEATSPAIN$hectares, probs = (11-1)/(17-1))
# (d) Vytvorte a zobrazte v tom istom grafickom okne frekvenčný histogram pre premennú acres 
# a hustotný histogram pre premennú acres. Na druhý histogram pridajte hustotnú krivku.

# (e) Vysvetlite, prečo použitie intervalov 0; 100,000; 250,000; 360,000; 1,550,000 v hist() 
# automaticky vytvorí hustotný histogram v základných grafických funkciách R.

# Koľkými spôsobmi môže hostiteľ náhodne vybrať 8 ľudí z 90 v publiku, ktorí sa zúčastnia na televíznej súťaži?
choose(90,8)
# 6
# Univerzitná komisia o veľkosti 10, ktorá sa skladá z 2 pedagógov z fakulty výtvarného a aplikovaného umenia, 
# 2 pedagógov z fakulty obchodu, 3 pedagógov z fakulty umení a vied a 3 administrátorov, 
# má byť vybraná zo 6 pedagógov z fakulty výtvarného a aplikovaného umenia, 7 pedagógov z fakulty obchodu, 
# 10 pedagógov z fakulty umení a vied a 5 administrátorov. Koľko komisií je možné vytvoriť?
TN <- choose(6,2)*choose(7,2)*choose(10,3)*choose(5,3)
TN
# 7
# Koľko rôznych usporiadaní písmen môže byť vytvorených z písmen slov BIOLOGY, PROBABILITY a STATISTICS?
B <- factorial(7)/factorial(2)
P <- factorial(11)/(factorial(2)*factorial(2))
S <- factorial(10)/(factorial(3)*factorial(3)*factorial(2))
c(B,P,S)
# 20
# Triatlonový klub ASU pozostáva z 11 žien a 7 mužov. Aká je pravdepodobnosť, že sa vyberie výbor veľkosti štyri s presne troma ženami?
choose(11,3)*choose(7,1)/choose(18,4)
# 29
# Nový test na drogy, ktorý zvažuje Medzinárodný olympijský výbor, dokáže zistiť prítomnosť zakázanej látky, 
# ak bola užitá subjektom v posledných 90 dňoch, v 98% prípadov. Test však tiež vykazuje "falošne pozitívne" výsledky u 2% populácie, 
# ktorá nikdy neužila zakázanú látku. Ak 2% športovcov užíva zakázanú látku, aká je pravdepodobnosť, že osoba, 
# ktorá mala pozitívny test na drogy, naozaj užíva zakázanú látku?
P_B_given_A <- 0.98  # pravdepodobnosť, že test pozitivny, ak človek uživa droga
P_A <- 0.02  # pravdepodobnosť, že človek uživa drogy
P_B_given_not_A <- 0.02  # pravdepodobnosť falošne poyitivnoho testa, ak človek nevyuživa drogy
P_not_A <- 0.98  # pravdepodobnosť, že človek nevyuživa drogy
P_B <- (P_B_given_A * P_A) + (P_B_given_not_A * P_not_A)
P_A_given_B <- (P_B_given_A * P_A) / P_B
P_A_given_B


# Z balíčka 52 kariet vyťahujeme 3 karty.
# Vypočítajte pravdepodobnosť, že:
# a) Všetky 3 karty sú esá (bez vrátenia)
choose(4,3)/choose(52,3)
# b) Všetky 3 karty sú rovnakej farby (s vrátením)
choose(26,3)*2/choose(52,3)
# c) Všetky 3 karty sú srdcové (s vrátením)
choose(13,3)/choose(52,3)

# V nádobe je 6 čiernych a 3 biele guličky. Náhodne vyberáme 4 guličky. 
# Náhodná premenná Z určuje počet bielych guličiek.
# Vypočítajte:
# a) Pravdepodobnostnú funkciu pre Z
Z <- function(x){
  choose(3,x)*choose(6,4-x)/choose(9,4)
}
sapply(0:3, Z)
# b) Strednú hodnotu E(Z)
E_Z <- 4*3/9
E_Z
# c) 3. kvartil Z
cumulative_probs <- cumsum(sapply(0:3, Z))
min(which(cumulative_probs >= 0.75))

# d) P(2 < Z < 4)
sapply(3, Z)

# Hádžeme tromi hracími kockami (1-6).
# a) Ak na prvej kocke padne 2, aká je pravdepodobnosť, že súčet všetkých troch bude 4
1/6*1/6
# b) Pravdepodobnosť, že na prvej a druhej padne párne číslo a na tretej nepárne
1/2*1/2*1/2
# c) Pravdepodobnosť, že na druhej a tretej kocke padne súčet 5
(1/6*1/6)+(1/6*1/6)+(1/6*1/6)+(1/6*1/6)

# V dielni je 7 strojov, pričom vždy 2 z nich sú nefunkčné.
# a) Náhodne vybraný stroj bude funkčný
5/7
# b) Presne 2. a 5. stroj budú nefunkčné
2/7*1/7
# c) Posledný stroj bude funkčný
5/7

# 3
# Stlpec "Age" ma čiselny format
# V stlpce "Age" existuju data (neexistuju žiadne chybajuce hodnoty)
# V stlpce "Age" neexistuju hodnoty Inf
# 4 boxplot 1,2,2,3,3,4,4,4
# skwed - искажено
# outlier - отклонение
# Rôydelenie hodnôt nie je asymetricke (nema žiadny offset)
# žiadne emisie
# plate late
# "PLATE" ma 120 rôznych permutaci
# "LATEE" ma 60 rôznych permutaci


#2.

mean1 <- -30*0.7 + -5*0.1 + 0*0.1 + 30*0.1
mean1


#3

adam <- choose(11,5)
adam
brano <- choose(11,6)
brano

#4

data <- (c(1,2,2,3,3,4,4,4))
boxplot(data, horizontal = TRUE)


#5
#RANO
#RANA

rano <- factorial(4)
rano

rana <- factorial(4)/factorial(2)
rana


#6

x <- -4
u <-7
w <- (x)^u
w


#8

fair <- 66000*0.01 + 12000 *0.2
fair


#9

pera <- 0.72 * 0.02 + 0.28 * 0.11
pera * 100


#10

top <- 0.94*0.05 
bot <- top + 0.94*0.045
top/bot

#11
z <-c(-9,-3,-6,0)
s <- c(1,1,0,1)

z%*%s



