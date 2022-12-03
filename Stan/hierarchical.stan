data {

  int<lower=0> N; // number of observations
  vector[N] SAT_ALL; // SAT score
  vector[N] MD_FAMINIC; // medain family income
  vector[N] AGE_ENTRY; // average age of entry
  vector[N] COSTT4_A; // average cost of education
  vector[N] POVERTY_RATE; // poverty rate in school area
  vector[N] PRIVATE; // private university dummy
  vector[N] y; // median earnings
  int<lower=0> K; // number of regions
  int<lower=1, upper=K> x[N]; // discrete group indicators

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
  real<lower=0> sigma; // shared standard deviation

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

  real mu_MASTER;
  real<lower=0> sigma_MASTER;

  real mu_PRIVATE;
  real<lower=0> sigma_PRIVATE;

}

model {

  // weakly informative priors
  beta_SAT_ALL ~ normal(43, 500);
  beta_MD_FAMINIC ~ normal(0, 100);
  beta_AGE_ENTRY ~ normal(0, 2500);
  beta_COSTT4_A ~ normal(0, 500);
  beta_POVERTY_RATE ~ normal(0, 2500);
  beta_MASTER ~ normal(0, 2500);
  beta_PRIVATE ~ normal(0, 2500);

  mu_SAT_ALL ~  normal(0, 500);
  sigma_SAT_ALL ~ inv_chi_square(1);
  beta_SAT_ALL ~ normal(mu_SAT_ALL, sigma_SAT_ALL);

  mu_MD_FAMINIC ~  normal(0, 500);
  sigma_MD_FAMINIC ~ inv_chi_square(1);
  beta_MD_FAMINIC ~ normal(mu_MD_FAMINIC, sigma_MD_FAMINIC);

  mu_AGE_ENTRY ~  normal(0, 500);
  sigma_AGE_ENTRY ~ inv_chi_square(1);
  beta_AGE_ENTRY ~ normal(mu_AGE_ENTRY, sigma_AGE_ENTRY);


  mu_COSTT4_A ~  normal(0, 500);
  sigma_COSTT4_A ~ inv_chi_square(1);
  beta_AGE_ENTRY ~ normal(mu_AGE_ENTRY, sigma_AGE_ENTRY);

  mu_POVERTY_RATE ~  normal(0, 500);
  sigma_POVERTY_RATE ~ inv_chi_square(1);

  mu_MASTER ~  normal(0, 500);
  sigma_MASTER ~ inv_chi_square(1);

  mu_PRIVATE ~  normal(0, 500);
  sigma_PRIVATE ~ inv_chi_square(1);


  // likelihoods
  for (i in 1:N) {
    y[i] ~ normal(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] *
    MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] +
    beta_POVERTY_RATE[x[i]] * POVERTY_RATE[i] + beta_MASTER[x[i]] * MASTER[i] +
    beta_PRIVATE[x[i]] * PRIVATE[i], sigma);
  }

}

generated quantities {

  vector[N] log_lik;

  for (i in 1:N) {log_lik[i] = normal_lpdf(y[i] | alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] *
    MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] +
    beta_POVERTY_RATE[x[i]] * POVERTY_RATE[i] + beta_MASTER[x[i]] * MASTER[i] +
    beta_PRIVATE[x[i]] * PRIVATE[i], sigma);
 }

}
