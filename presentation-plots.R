hist(data.joined.stan$MD_EARN_WNE_P10, breaks = 30, xlab = "MD_EARN_WNE_P10 ($/yr)", ylab = "Frequency", main = NA)
hist(data.joined.stan$SAT_ALL, breaks = 30, xlab = "SAT_ALL", ylab = "Frequency", main = NA)
hist(data.joined.stan$AGE_ENTRY, breaks = 30, xlab = "Age of entry", ylab = "Frequency", main = NA)
hist(data.joined.stan$POVERTY_RATE, breaks = 30, xlab = "Poverty rate", ylab = "Frequency", main = NA)

boxplot(data.joined.stan$MD_EARN_WNE_P10)
boxplot(data.joined.stan$SAT_ALL)
boxplot(data.joined.stan$AGE_ENTRY)
boxplot(data.joined.stan$POVERTY_RATE)