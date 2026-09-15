# -------------------------------------------------------------------
# Študentovo t-rozdelenie – pravdepodobnosti
# T ~ t(12)

# a) P(T < 1.8)
pt(1.8, 12)

# b) P(0.5 < T < 1.8)
pt(1.8, 12) - pt(0.5, 12)

# c) Kvantil a pre P(T < a) = 0.975
qt(0.975, 12)


# -------------------------------------------------------------------
# Chí-kvadrát rozdelenie – pravdepodobnosti a kvantily
# X ~ χ²(15)

# a) P(X > 25)
pchisq(25, 15, lower.tail = FALSE)

# b) P(10 < X < 25)
pchisq(25, 15) - pchisq(10, 15)

# c) Kvantil b pre P(X < b) = 0.90
qchisq(0.90, 15)


# -------------------------------------------------------------------
# Jednovýberový t-interval pre strednú hodnotu
# n = 40, priemer = 5.3, smerodajná odchýlka = 0.8

# Dolná hranica intervalu
5.3 - qt(0.975, 39) * 0.8 / sqrt(40)

# Horná hranica intervalu
5.3 + qt(0.975, 39) * 0.8 / sqrt(40)


# -------------------------------------------------------------------
# Interval spoľahlivosti pre rozptyl normálnej populácie
# n = 40, rozptyl vzorky s² = 0.64

# Dolná hranica intervalu pre σ²
(39 * 0.64) / qchisq(0.995, 39)

# Horná hranica intervalu pre σ²
(39 * 0.64) / qchisq(0.005, 39)


# -------------------------------------------------------------------
# Dvojvýberový t-test – rozdiel stredných hodnôt
# n₁ = 25, priemer₁ = 78.4, smerodajná odchýlka₁ = 6.2
# n₂ = 22, priemer₂ = 74.9, smerodajná odchýlka₂ = 5.4

# Výpočet spoločného odhadu rozptylu (pooled variance)
sp2 <- ((24 * 6.2^2) + (21 * 5.4^2)) / 45

# Dolná hranica intervalu pre rozdiel stredných hodnôt
(78.4 - 74.9) - qt(0.975, 45) * sqrt(sp2 * (1/25 + 1/22))

# Horná hranica intervalu pre rozdiel stredných hodnôt
(78.4 - 74.9) + qt(0.975, 45) * sqrt(sp2 * (1/25 + 1/22))


# -------------------------------------------------------------------
# Binomické rozdelenie – pravdepodobnosť a interval pre p
# n = 120, počet úspechov k = 87

# Pravdepodobnosť presne 87 úspechov
dbinom(87, 120, 87/120)

# Výpočet podielu úspechov (p-hat)
p <- 87/120

# Dolná hranica Waldovho intervalu pre p
p - qnorm(0.975) * sqrt(p * (1 - p) / 120)

# Horná hranica Waldovho intervalu pre p
p + qnorm(0.975) * sqrt(p * (1 - p) / 120)
