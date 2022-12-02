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
  int<lower=0> K; // number of groups
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
  mu_SAT_ALL ~  normal(43, 100);
  sigma_SAT_ALL ~ normal(500, 100);
  beta_SAT_ALL ~ normal(mu_SAT_ALL, sigma_SAT_ALL);
  
  mu_MD_FAMINIC ~  normal(0, 10);
  sigma_MD_FAMINIC ~ normal(100, 100);
  beta_MD_FAMINIC ~ normal(mu_MD_FAMINIC, sigma_MD_FAMINIC);

  mu_AGE_ENTRY ~  normal(0, 500);
  sigma_AGE_ENTRY ~ normal(2500, 500);
  beta_AGE_ENTRY ~ normal(mu_AGE_ENTRY, sigma_AGE_ENTRY);

  mu_COSTT4_A ~  normal(0, 50);
  sigma_COSTT4_A ~ normal(500, 500);
  beta_COSTT4_A ~ normal(mu_COSTT4_A, sigma_COSTT4_A);

  mu_POVERTY_RATE ~  normal(0, 500);
  sigma_POVERTY_RATE ~ normal(2500, 500);
  beta_POVERTY_RATE ~ normal(mu_POVERTY_RATE, sigma_POVERTY_RATE);
  
  mu_MASTER ~  normal(0, 500);
  sigma_MASTER ~ normal(2500, 500);
  beta_MASTER ~ normal(mu_MASTER, sigma_MASTER);

  mu_PRIVATE ~  normal(0, 500);
  sigma_PRIVATE ~ normal(2500, 500);
  beta_PRIVATE ~ normal(mu_PRIVATE, sigma_PRIVATE);

  
  // likelihoods
  for (n in 1:N) {
    y[n] ~ normal(alpha[x[n]] + beta_SAT_ALL[x[n]] * SAT_ALL[n] + 
    beta_MD_FAMINIC[x[n]] * MD_FAMINIC[n] + beta_AGE_ENTRY[x[n]] * 
    AGE_ENTRY[n] + beta_COSTT4_A[x[n]] * COSTT4_A[n] +
    beta_POVERTY_RATE[x[n]] * POVERTY_RATE[n] + beta_MASTER[x[n]] * MASTER[n] +
    beta_PRIVATE[x[n]] * PRIVATE[n], sigma);
  }
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_rep;
  
  for (i in 1:N) {
    
    log_lik[i] = normal_lpdf(y[i] | alpha[x[i]] + beta_SAT_ALL[x[i]] * 
    SAT_ALL[i] + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * 
    AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]] * 
    POVERTY_RATE[i] + beta_MASTER[x[i]] * MASTER[i] + beta_PRIVATE[x[i]] * 
    PRIVATE[i], sigma);
    
    y_rep[i] = normal_rng(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] 
    + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_AGE_ENTRY[x[i]] * 
    AGE_ENTRY[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]] * 
    POVERTY_RATE[i] + beta_MASTER[x[i]] * MASTER[i] + beta_PRIVATE[x[i]] * 
    PRIVATE[i], sigma);
 }

}