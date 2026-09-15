old <- c(182.47, 175.53, 181.71, 179.03, 177.28,
         177.49, 179.54, 185.12, 179.04, 180.50,
         182.15, 183.55, 180.86, 180.82, 178.88)

new <- c(195.64, 196.31, 190.33, 192.90, 193.24,
         193.05, 193.87, 196.39, 195.25, 194.48,
         197.33, 193.81, 198.03, 193.31, 198.43)

GLUCOSE <- data.frame(Patient = paste0("Patient", 1:15),
                      Old = old,
                      New = new)

mean_old <- mean(GLUCOSE$Old)
mean_new <- mean(GLUCOSE$New)
mean_diff <- mean(GLUCOSE$New - GLUCOSE$Old)
cat("Mean Old:", mean_old, "\n",
    "Mean New:", mean_new, "\n",
    "Mean(New – Old):", mean_diff, "\n")

t_res <- t.test(GLUCOSE$New,
                GLUCOSE$Old,
                paired = TRUE,
                alternative = "greater")
print(t_res)

