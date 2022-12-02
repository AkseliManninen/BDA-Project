data {
  int<lower=0> N; // number of observations
  vector[N] SAT_ALL;
  vector[N] MD_FAMINIC;
  vector[N] AGE_ENTRY;
  vector[N] COSTT4_A;
  vector[N] POVERTY_RATE;
  vector[N] MASTER;
  vector[N] PRIVATE;
  vector[N] y;
}

parameters {
  real alpha;
  real beta_SAT_ALL;
  real beta_MD_FAMINIC;
  real beta_AGE_ENTRY;
  real beta_COSTT4_A;
  real beta_POVERTY_RATE;
  real beta_MASTER;
  real beta_PRIVATE;
  real<lower=0> sigma;

}

model {
  // weekly informative priors
  beta_SAT_ALL ~ normal(43, 500);
  beta_MD_FAMINIC ~ normal(0, 100);
  beta_AGE_ENTRY ~ normal(0, 2500);
  beta_COSTT4_A ~ normal(0, 500);
  beta_POVERTY_RATE ~ normal(0, 2500);
  beta_MASTER ~ normal(0, 2500);
  beta_PRIVATE ~ normal(0, 2500);


  y ~ normal(alpha + beta_SAT_ALL * SAT_ALL + beta_MD_FAMINIC * MD_FAMINIC +
  beta_AGE_ENTRY * AGE_ENTRY + beta_COSTT4_A * COSTT4_A +
  beta_POVERTY_RATE * POVERTY_RATE + beta_MASTER * MASTER +
  beta_PRIVATE * PRIVATE, sigma);
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;

  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | alpha + beta_SAT_ALL * SAT_ALL
    + beta_MD_FAMINIC * MD_FAMINIC + beta_AGE_ENTRY * AGE_ENTRY +
    beta_COSTT4_A * COSTT4_A + beta_POVERTY_RATE * POVERTY_RATE +
    beta_MASTER * MASTER + beta_PRIVATE * PRIVATE, sigma);
    
    y_rep[i] = normal_rng(alpha + beta_SAT_ALL * SAT_ALL[i]
    + beta_MD_FAMINIC * MD_FAMINIC[i] + beta_AGE_ENTRY * AGE_ENTRY[i] +
    beta_COSTT4_A * COSTT4_A[i] + beta_POVERTY_RATE * POVERTY_RATE[i] +
    beta_MASTER * MASTER[i] + beta_PRIVATE * PRIVATE[i], sigma);
  }
}
