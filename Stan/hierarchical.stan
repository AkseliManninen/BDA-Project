data {

  int<lower=0> N; // number of observations
  int<lower=0> K; // number of regions
  int<lower=1, upper=K> x[N]; // discrete group indicators

  // data vectors
  vector[N] SAT_ALL; // SAT score
  vector[N] MD_FAMINIC; // medain family income
  vector[N] AGE_ENTRY; // average age of entry
  vector[N] COSTT4_A; // average cost of education
  vector[N] POVERTY_RATE; // poverty rate in school area
  vector[N] PRIVATE; // private innstitution dummy
  vector[N] y; // median earnings

  // params for prior distributions
  real pm_alpha; // prior mean of intercept term
  real ps_alpha; // prior sd of intercept term
  real pm_s_alpha; // sd of prior mean of intercept term
  real ps_s_alpha; // sd of prior sd of intercept term

  real pm_SAT_ALL;
  real ps_SAT_ALL;
  real pm_s_SAT_ALL;
  real ps_s_SAT_ALL;

  real pm_MD_FAMINC;
  real ps_MD_FAMINC;
  real pm_s_MD_FAMINC;
  real ps_s_MD_FAMINC;

  real pm_AGE_ENTRY;
  real ps_AGE_ENTRY;
  real pm_s_AGE_ENTRY;
  real ps_s_AGE_ENTRY;

  real pm_COSTT4_A;
  real ps_COSTT4_A;
  real pm_s_COSTT4_A;
  real ps_s_COSTT4_A;

  real pm_POVERTY_RATE;
  real ps_POVERTY_RATE;
  real pm_s_POVERTY_RATE;
  real ps_s_POVERTY_RATE;

  real pm_PRIVATE;
  real ps_PRIVATE;
  real pm_s_PRIVATE;
  real ps_s_PRIVATE;

  real pm_sigma;
  real ps_sigma;
  real pm_s_sigma;
  real ps_s_sigma;

}

parameters {

  vector[K] alpha;
  vector[K] beta_SAT_ALL;
  vector[K] beta_MD_FAMINIC;
  vector[K] beta_AGE_ENTRY;
  vector[K] beta_COSTT4_A;
  vector[K] beta_POVERTY_RATE;
  vector[K] beta_PRIVATE;
  real<lower=0> sigma; // common standard deviation

  real mu_alpha;
  real<lower=0> sigma_alpha;

  real mu_SAT_ALL;
  real<lower=0> sigma_SAT_ALL;

  real mu_MD_FAMINIC;
  real<lower=0> sigma_MD_FAMINIC;

  real mu_AGE_ENTRY;
  real<lower=0> sigma_AGE_ENTRY;

  real mu_COSTT4_A;
  real<lower=0> sigma_COSTT4_A;

  real mu_POVERTY_RATE;
  real<lower=0> sigma_POVERTY_RATE;

  real mu_PRIVATE;
  real<lower=0> sigma_PRIVATE;

  real mu_sigma;
  real<lower=0> sigma_sigma;

}

model {

  mu_alpha ~ normal(pm_alpha, pm_s_alpha);
  sigma_alpha ~ normal(ps_alpha, ps_s_alpha);
  alpha ~ normal(mu_alpha, sigma_alpha);

  mu_SAT_ALL ~  normal(pm_SAT_ALL, pm_s_SAT_ALL);
  sigma_SAT_ALL ~ normal(ps_SAT_ALL, ps_s_SAT_ALL);
  beta_SAT_ALL ~ normal(mu_SAT_ALL, sigma_SAT_ALL);

  mu_MD_FAMINIC ~  normal(pm_MD_FAMINC, pm_s_MD_FAMINC);
  sigma_MD_FAMINIC ~ normal(ps_MD_FAMINC, ps_s_MD_FAMINC);
  beta_MD_FAMINIC ~ normal(mu_MD_FAMINIC, sigma_MD_FAMINIC);

  mu_AGE_ENTRY ~  normal(pm_AGE_ENTRY, pm_s_AGE_ENTRY);
  sigma_AGE_ENTRY ~ normal(ps_AGE_ENTRY, ps_s_AGE_ENTRY);
  beta_AGE_ENTRY ~ normal(mu_AGE_ENTRY, sigma_AGE_ENTRY);

  mu_COSTT4_A ~  normal(pm_COSTT4_A, pm_s_COSTT4_A);
  sigma_COSTT4_A ~ normal(ps_COSTT4_A, ps_s_COSTT4_A);
  beta_COSTT4_A ~  normal(mu_COSTT4_A, sigma_COSTT4_A);

  mu_POVERTY_RATE ~  normal(pm_POVERTY_RATE, pm_s_POVERTY_RATE);
  sigma_POVERTY_RATE ~ normal(ps_POVERTY_RATE, ps_s_POVERTY_RATE);
  beta_POVERTY_RATE ~ normal(mu_POVERTY_RATE, sigma_POVERTY_RATE);

  mu_PRIVATE ~  normal(pm_PRIVATE, pm_s_PRIVATE);
  sigma_PRIVATE ~ normal(ps_PRIVATE, ps_s_PRIVATE);
  beta_PRIVATE ~ normal(mu_PRIVATE, sigma_PRIVATE);

  mu_sigma ~ normal(pm_sigma, pm_s_sigma);
  sigma_sigma ~ normal(ps_sigma, ps_s_sigma);
  sigma ~ normal(mu_sigma, sigma_sigma);


  // likelihoods
  for (i in 1:N) {
    y[i] ~ normal(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]] * POVERTY_RATE[i] + beta_PRIVATE[x[i]] * PRIVATE[i], sigma);
  }

}

generated quantities {

  vector[N] log_lik;
  vector[N] y_rep;

  for (i in 1:N) {

    log_lik[i] = normal_lpdf(y[i] | alpha[x[i]] + beta_SAT_ALL[x[i]] *
    SAT_ALL[i] + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] *
    AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]] *
    POVERTY_RATE[i] + beta_PRIVATE[x[i]] *
    PRIVATE[i], sigma);

    y_rep[i] = normal_rng(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i]
    + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] *
    AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]] *
    POVERTY_RATE[i] + beta_PRIVATE[x[i]] *
    PRIVATE[i], sigma);
 }


}
