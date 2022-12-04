data {

  int<lower=0> N; // number of observations

  // data vectors
  vector[N] SAT_ALL;
  vector[N] MD_FAMINIC;
  vector[N] COSTT4_A;
  vector[N] POVERTY_RATE;
  vector[N] URBAN;
  vector[N] PRIVATE;
  vector[N] y;

  // prior distribution parameters
  real pm_alpha; // prior mean of intercept term
  real ps_alpha; // prior sd of intercept term
  real pm_SAT_ALL;
  real ps_SAT_ALL;
  real pm_MD_FAMINC;
  real ps_MD_FAMINC;
  real pm_COSTT4_A;
  real ps_COSTT4_A;
  real pm_POVERTY_RATE;
  real ps_POVERTY_RATE;
  real pm_URBAN;
  real ps_URBAN;
  real pm_PRIVATE;
  real ps_PRIVATE;
  real pm_sigma;
  real ps_sigma;

}

parameters {
  real alpha;
  real beta_SAT_ALL;
  real beta_MD_FAMINIC;
  real beta_COSTT4_A;
  real beta_POVERTY_RATE;
  real beta_URBAN;
  real beta_PRIVATE;
  real<lower=0> sigma;

}

model {

  // weakly informative priors
  alpha ~ normal(pm_alpha, ps_alpha);
  beta_SAT_ALL ~ normal(pm_SAT_ALL, ps_SAT_ALL);
  beta_MD_FAMINIC ~ normal(pm_MD_FAMINC, ps_MD_FAMINC);
  beta_COSTT4_A ~ normal(pm_COSTT4_A, ps_COSTT4_A);
  beta_POVERTY_RATE ~ normal(pm_POVERTY_RATE, ps_POVERTY_RATE);
  beta_URBAN ~ normal(pm_URBAN, ps_URBAN);
  beta_PRIVATE ~ normal(pm_PRIVATE, ps_PRIVATE);
  sigma ~ normal(pm_sigma, ps_sigma);

  y ~ normal(alpha + beta_SAT_ALL * SAT_ALL + beta_MD_FAMINIC * MD_FAMINIC +
   beta_COSTT4_A * COSTT4_A +
  beta_POVERTY_RATE * POVERTY_RATE + beta_URBAN * URBAN +
  beta_PRIVATE * PRIVATE, sigma);
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;

  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | alpha + beta_SAT_ALL * SAT_ALL
    + beta_MD_FAMINIC * MD_FAMINIC +
    beta_COSTT4_A * COSTT4_A + beta_POVERTY_RATE * POVERTY_RATE + 
    beta_URBAN * URBAN + beta_PRIVATE * PRIVATE, sigma);

    y_rep[i] = normal_rng(alpha + beta_SAT_ALL * SAT_ALL[i]
    + beta_MD_FAMINIC * MD_FAMINIC[i] +
    beta_COSTT4_A * COSTT4_A[i] + beta_POVERTY_RATE * POVERTY_RATE[i] 
    + beta_URBAN * URBAN[i] + beta_PRIVATE * PRIVATE[i], sigma);
  }

}
