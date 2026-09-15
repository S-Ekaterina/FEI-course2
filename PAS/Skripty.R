module_cisla <- "abs(-5)"
koren_2 <- "sqrt(16"
okruglenie <- "round(cislo, pocet znakov posle .)"
okruglenie_up <- "ceiling(cislo)"
okruglenie_down <- "floor(cislo)"
e_stepen <- "exp(stepen)"
vektor <- "x <- c(2,5,8,1)"
dlina <- "length(x)"
povtor <- "rep(co opakovat, kolko krat)"
posledovat <- "seq(od akeho, po ake, krok(+5/-5))"
posled_pocet <- "seq(od akeho, po ake, pocet cisiel)"
random <- "runif(pocet cisiel, min, max)"
random2 <- "rnorm(pocet cisiel, srednee cislo, otklonenie)"
random_plotnost <- "dnorm(vektor/cislo, sredne, otklonenie)"
posmotr <- "str(nazov)"
mode_objekta <- "mode(nazov)"
class_objekta <- "class(nazov)"
priklad <- "example(komanda)"
grafik <- 'plot(1:10,1:10,masstab type="l"(line?),col="blue")'
tabulka <- "table(nazov)"
tabulka_prop <- "prop.table(nazov)"

example("dunif")
# norm -  normal distribution
runif(20, 10, 20) # 20 random cisiel od 10 do 20
rnorm(20, 10, 2) # 20 random cisiel, stred 10, otkonenie 2
punif(20, 0, 100) # pravdepodobnosť že nahodne čislo od 0 po 100 bude 20
pnorm(20, 10, 5) # pravdepodobnosť že nahodne čislo bude 20, kde 10 je stred, 5 - odchylka
dunif(20, 0, 100) # hustota pravdepodobnosti, 1 / (max - min) = 1/100 = 0.01
qunif(0.8, 0, 100) # pravdepodobnosť že čisla < 80%
qnorm(0.975, 10, 5) # pravdepodobnosť že čisla < 97,5%
median(c(100,1000)) # aritmeticky priemer
set.seed(12) # zapamäta nahodne čisla
table(Grades) # tabuľka (napr. kolko A, kolko B atd.)
xtabs (~Grades) # tabuľka napr. kolko A, kolko B atd.)
table(Grades)/length(Grades) # počet А,B,C,D,F vzťahom k počtu premennych
barplot(xtabs (~Grades), col = 'gray40' , xlab = 'Grades' ,
        + ylab = 'Frequency') # gystograma
seq(20, 70, 10) # vytvara postupnosť čisiel 20-70 s krokom 10







