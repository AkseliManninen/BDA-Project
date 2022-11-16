# READ IN DATA ----

# load libraries
library(tidyverse)
library(reshape2)

# read in data sets
data <- read.csv2("./Data/Most-Recent-Cohorts-Institution.csv", sep = ",") %>% as_tibble()
data.description <- read.csv2("./Data/CollegeScorecardDataDictionary.csv", sep = ",") %>% as_tibble()

# DATA MANIPULATION ----

# list variables
id.vars <- c("UNITID", "INSTNM", "CITY", "ST_FIPS", "REGION")
numerical.vars <- c("SATVRMID", "SATMTMID", "SATWRMID", "MD_FAMINC", "AGE_ENTRY", "FEMALE", "FIRST_GEN", "PCT_WHITE", "DEBT_MDN_SUPP", "C150_4", "COSTT4_A", "MD_EARN_WNE_P10", "POVERTY_RATE", "UNEMP_RATE", "MARRIED", "VETERAN")
categorical.vars <- c("LOCALE", "CCBASIC", "CONTROL")
SAT.vars <- c("SATVRMID", "SATMTMID", "SATWRMID") # helper variable later on

# create map for variable descriptions
variable.descriptions <- data.description %>%
  select(VARIABLE.NAME, NAME.OF.DATA.ELEMENT, NOTES) %>%
  filter(VARIABLE.NAME %in% c(id.vars, categorical.vars, numerical.vars))

# extract categorical variables
data.filtered.categorical <- data %>%
  select(all_of(id.vars), all_of(categorical.vars)) %>%
  mutate(across(.cols = all_of(categorical.vars), .fns = as.factor))

# drop rows with NA for categorical vars
data.filtered.categorical.dropna <- data.filtered.categorical %>%
  drop_na()

# extract numerical variables
data.filtered.numerical <- data %>%
  select(all_of(id.vars), all_of(numerical.vars)) %>%
  mutate(across(.cols = c(id.vars[1], numerical.vars), .fns = as.numeric))

# drop rows with NA for numerical vars
data.filtered.numerical.dropna <- data.filtered.numerical %>%
  drop_na()

# join categorical and numerical variables by id
data.filtered.numerical.dropna <- data.filtered.numerical.dropna %>%
  mutate(SAT_ALL = data.filtered.numerical.dropna %>%
           select(SATVRMID, SATMTMID, SATWRMID) %>%
           rowMeans())

data.filtered.all <- data.filtered.numerical.dropna %>%
  inner_join(data.filtered.categorical.dropna, by = id.vars)

# PRELIMINARY ANALYSIS ----

# summarize data
glimpse(data.filtered.all)
summary(data.filtered.all)

# make variable type specific data frames for plots etc.
numerical.vars.data <- data.filtered.all %>% select(!c(id.vars, categorical.vars, SAT.vars)) %>% relocate(MD_EARN_WNE_P10, 1)
categorical.vars.data <- data.filtered.all %>% select(all_of(categorical.vars))

# visualizations
corrplot::corrplot(cor(numerical.vars.data))
melted <- melt(numerical.vars.data, id.vars = "MD_EARN_WNE_P10")

ggplot(melted, aes(x = value, y = MD_EARN_WNE_P10)) +
  facet_wrap(~variable, scales = "free") +
  geom_point()

# preliminary model with all numerical vars (not yet categorical)
model <- lm(MD_EARN_WNE_P10 ~ ., data = numerical.vars.data)
summary(model)

# step wise regression implied "best" model in terms of AIC
step(model)
stepwise.model <- lm(MD_EARN_WNE_P10 ~ FEMALE + C150_4 + COSTT4_A + POVERTY_RATE +
  UNEMP_RATE + MARRIED + SAT_ALL, data = numerical.vars.data)
summary(stepwise.model)

# numerical + categorical vars model
full.model.data <- data.filtered.all %>%
  select(!c(id.vars, SAT.vars))
model.full <- lm(MD_EARN_WNE_P10 ~ ., full.model.data)
summary(model.full)

# TO DO: ----
# - see what data we have from id.vars, e.g., CCBASIC implies that subset might be to small
# - choose predictors such that we get a sufficiently large sample of schools
# - consider filtering the data such that we focus on e.g., certain types of schools
# - visualize categorical vars after choosing filtering to ensure we have enough variability
# - sanity check variables such that they are surely comparable (data comes from different sources)
# - start to think about hierarchical structure after ensuring sufficient amount of data
# - If hierarchical structure does not work, start to think about nonlinear models, data clearly shows some nonlinear relationships with earnings. For example, married and cost of education