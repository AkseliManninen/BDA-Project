# READ IN DATA ----

# load libraries
library(tidyverse)
library(reshape2)
library(ggcorrplot)

# read in data sets
data <- read.csv2("./Data/Most-Recent-Cohorts-Institution.csv", sep = ",", fileEncoding="UTF-8-BOM") %>% as_tibble()
data.description <- read.csv2("./Data/CollegeScorecardDataDictionary.csv", sep = ",", fileEncoding="UTF-8-BOM") %>% as_tibble()

# DATA MANIPULATION ----

# list variables
id.vars <- c("UNITID", "INSTNM", "CITY", "ST_FIPS", "REGION")
numerical.vars <- c("SATVRMID", "SATMTMID", "MD_FAMINC", "AGE_ENTRY", "FEMALE", "FIRST_GEN", "PCT_WHITE", "DEBT_MDN_SUPP", "C150_4", "COSTT4_A", "MD_EARN_WNE_P10", "POVERTY_RATE", "UNEMP_RATE", "MARRIED")
categorical.vars <- c("LOCALE", "CCBASIC", "CONTROL")
SAT.vars <- c("SATVRMID", "SATMTMID")

# filter specific school types
schooltype.filter <- seq(14,23)
region.filter <- seq(1,8)

# create map for variable descriptions
variable.descriptions <- data.description %>%
  select(VARIABLE.NAME, NAME.OF.DATA.ELEMENT, NOTES) %>%
  filter(VARIABLE.NAME %in% c(id.vars, categorical.vars, numerical.vars))

# extract categorical variables
data.categorical <- data %>%
  select(all_of(id.vars), all_of(categorical.vars)) %>%
  mutate(across(.cols = all_of(categorical.vars), .fns = as.factor))

data.categorical.dropna <- data.categorical %>%
  drop_na()

# extract numerical variables
data.numerical <- data %>%
  select(all_of(id.vars), all_of(numerical.vars)) %>%
  mutate(across(.cols = c(id.vars[1], numerical.vars), .fns = as.numeric))

data.numerical.dropna <- data.numerical %>%
  drop_na()

# aggregate SAT scores
data.numerical.dropna <- data.numerical.dropna %>%
  mutate(SAT_ALL = data.numerical.dropna %>%
           select(SATVRMID, SATMTMID) %>%
           rowMeans()
         )

data.joined <- data.numerical %>%
  inner_join(data.categorical, by = id.vars) %>%
  filter(CCBASIC %in% schooltype.filter & REGION %in% region.filter)

data.joined.dropna <- data.numerical.dropna %>%
  inner_join(data.categorical.dropna, by = id.vars) %>%
  filter(CCBASIC %in% schooltype.filter & REGION %in% region.filter)

# PRELIMINARY ANALYSIS ----

# summarize data
glimpse(data.joined.dropna)
summary(data.joined.dropna)

# make variable type specific data frames for plots etc.
numerical.vars.data <- data.joined.dropna %>% select(!c(id.vars, categorical.vars, SAT.vars)) %>% relocate(MD_EARN_WNE_P10, 1)

categorical.vars.data <- data.joined.dropna %>%
  select(all_of(categorical.vars), MD_EARN_WNE_P10) %>%
  relocate(MD_EARN_WNE_P10, 1)

# VISUALIZATION ----

# correlation between numerical variables
r <- cor(numerical.vars.data)
ggcorrplot(r,
           hc.order = TRUE,
           type = "full",
           lab = TRUE,
           title = "Correlation between numerical variables")


# scatter plot between predictors and earnings
melted.numerical <- melt(numerical.vars.data, id.vars = "MD_EARN_WNE_P10")
ggplot(melted.numerical, aes(x = value, y = MD_EARN_WNE_P10)) +
  facet_wrap(~variable, scales = "free") +
  geom_point()

# categorical variable box plots
melted.categorial <- melt(categorical.vars.data, id.vars = "MD_EARN_WNE_P10")
melted.categorial.ccbasic <- melted.categorial %>% as_tibble() %>% filter(variable=="CCBASIC")
melted.categorial.control <- melted.categorial %>% as_tibble() %>% filter(variable=="CONTROL")
melted.categorial.locale <- melted.categorial %>% as_tibble() %>% filter(variable=="LOCALE")

ggplot(melted.categorial.ccbasic, aes(x=value, y=MD_EARN_WNE_P10, fill=value)) +
  geom_boxplot() +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("University types") +
  xlab("CCBASIC")

ggplot(melted.categorial.control, aes(x=value, y=MD_EARN_WNE_P10, fill=value)) +
  geom_boxplot() +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Public vs. Private") +
  xlab("CONTROL")

ggplot(melted.categorial.locale, aes(x=value, y=MD_EARN_WNE_P10, fill=value)) +
  geom_boxplot() +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  theme(
    legend.position="none",
    plot.title = element_text(size=11)
  ) +
  ggtitle("Location of school") +
  xlab("LOCALE")

# MODELING ----

data.joined.model <- data.joined.dropna %>%
  mutate(URBAN = case_when(LOCALE %in% c(seq(11,13), seq(21,23)) ~ 1,
                           TRUE ~ 0),
         PRIVATE = case_when(CONTROL %in% c(2,3) ~ 1,
                             TRUE ~ 0),
         DOCTORAL = case_when(CCBASIC %in% seq(15,17) ~ 1,
                              TRUE ~ 0),
         MASTER = case_when(CCBASIC %in% seq(18,20) ~ 1,
                            TRUE ~ 0)
  )


numerical.vars.model <- c("MD_EARN_WNE_P10", "SAT_ALL", "MD_FAMINC", "AGE_ENTRY", "COSTT4_A", "POVERTY_RATE")
categorical.vars.model <- c("URBAN", "PRIVATE", "DOCTORAL", "MASTER")

# baseline model
model <- lm(MD_EARN_WNE_P10 ~ ., data = data.joined.model)
summary(model)

# step wise regression implied "best" model in terms of AIC
step(model, direction = "backward")
stepwise.model <- lm(formula = MD_EARN_WNE_P10 ~ SAT_ALL + MD_FAMINC + COSTT4_A + POVERTY_RATE + URBAN + PRIVATE + MASTER, data = data.joined.model)
summary(stepwise.model)


# EXPORT DATA ----

# data with REGION identifier for STAN
data.joined.stan <- data.joined.model %>%
  select(REGION, all_of(numerical.vars.model), all_of(categorical.vars.model))

# data for linear regression model in R
data.joined.model <- data.joined.stan %>%
  select(-REGION)

write.csv(x = numerical.vars.data, file = "./Data/numerical.vars.data.csv", row.names = FALSE)
write.csv(x = categorical.vars.data, file = "./Data/categorical.vars.data.csv", row.names = FALSE)
write.csv(x = data.joined.stan, file = "./Data/data.joined.stan.csv", row.names = FALSE)