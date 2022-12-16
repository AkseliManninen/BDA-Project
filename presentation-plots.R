hist(data.joined.stan$MD_EARN_WNE_P10, breaks = 30, main = NA, xlab = NA)
hist(data.joined.stan$SAT_ALL, breaks = 30, main = NA, xlab = NA)
hist(data.joined.stan$AGE_ENTRY, breaks = 30, main = NA, xlab = NA)
hist(data.joined.stan$POVERTY_RATE, breaks = 30, main = NA, xlab = NA)

boxplot(data.joined.stan$MD_EARN_WNE_P10)
boxplot(data.joined.stan$SAT_ALL)
boxplot(data.joined.stan$AGE_ENTRY)
boxplot(data.joined.stan$POVERTY_RATE)