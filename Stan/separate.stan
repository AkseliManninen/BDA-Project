data {

  // number of observations
  int<lower=0> N;

  // number of regions
  int<lower=0> K;

  // region indicators
  int<lower=1, upper=K> x[N];

  // data vectors
  vector[N] SAT_ALL; // composite SAT score
  vector[N] MD_FAMINIC; // median family income
  vector[N] AGE_ENTRY; // age of entry
  vector[N] COSTT4_A; // cost of education
  vector[N] POVERTY_RATE; // povery rate
  vector[N] MASTER; // masters degree dummy
  vector[N] PRIVATE; // private institution dummy
  vector[N] y; // dependent variable (median earnings 10 years post-graduation)

  // prior parameters
  real pm_alpha; // prior mean of intercept term
  real ps_alpha; // prior sd of intercept term
  real pm_SAT_ALL;
  real ps_SAT_ALL;
  real pm_MD_FAMINC;
  real ps_MD_FAMINC;
  real pm_AGE_ENTRY;
  real ps_AGE_ENTRY;
  real pm_COSTT4_A;
  real ps_COSTT4_A;
  real pm_POVERTY_RATE;
  real ps_POVERTY_RATE;
  real pm_MASTER;
  real ps_MASTER;
  real pm_PRIVATE;
  real ps_PRIVATE;
  real pm_sigma;
  real ps_sigma;

}

parameters {

  vector[K] alpha;
  vector[K] beta_SAT_ALL;
  vector[K] beta_MD_FAMINIC;
  vector[K] beta_AGE_ENTRY;
  vector[K] beta_COSTT4_A;
  vector[K] beta_POVERTY_RATE;
  vector[K] beta_MASTER;
  vector[K] beta_PRIVATE;
  vector<lower=0>[K] sigma;

}

model {

  // weakly informative prior distributions
  for (j in 1:K) {
    alpha[j] ~ normal(pm_alpha, ps_alpha);
    beta_SAT_ALL[j] ~ normal(pm_SAT_ALL, ps_SAT_ALL);
    beta_MD_FAMINIC[j] ~ normal(pm_MD_FAMINC, ps_MD_FAMINC);
    beta_AGE_ENTRY[j] ~ normal(pm_AGE_ENTRY, ps_AGE_ENTRY);
    beta_COSTT4_A[j] ~ normal(pm_COSTT4_A, ps_COSTT4_A);
    beta_POVERTY_RATE[j] ~ normal(pm_POVERTY_RATE, ps_POVERTY_RATE);
    beta_MASTER[j] ~ normal(pm_MASTER, ps_MASTER);
    beta_PRIVATE[j] ~ normal(pm_PRIVATE, ps_PRIVATE);
  }


  // likelihoods
  for (i in 1:N) {
    y[i] ~ normal(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] *
    MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] +
    beta_POVERTY_RATE[x[i]] * POVERTY_RATE[i] + beta_MASTER[x[i]] * MASTER[i] +
    beta_PRIVATE[x[i]] * PRIVATE[i], sigma);
  }

}

generated quantities {
  vector[N] log_lik; // to do
}
