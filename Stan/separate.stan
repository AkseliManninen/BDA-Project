data {

  int<lower=0> N; // number of observations in training set
  int<lower=0> N_tilde; // number of observations in test set
  
  int<lower=0> K; // number of regions
  int<lower=1, upper=K> x[N]; // discrete group indicators in training set
  int<lower=1, upper=K> x_tilde[N_tilde]; // discrete group indicators in test set

  // data vectors
  vector[N] SAT_ALL; // composite SAT score
  vector[N] MD_FAMINIC; // median family income
  vector[N] COSTT4_A; // cost of education
  vector[N] POVERTY_RATE; // povery rate
  vector[N] URBAN; // urban dummy
  vector[N] PRIVATE; // private institution dummy
  vector[N] y; // dependent variable (median earnings 10 years post-graduation)

  // data vectors test set
  vector[N_tilde] SAT_ALL_test; // SAT score
  vector[N_tilde] MD_FAMINIC_test; // medain family income
  vector[N_tilde] COSTT4_A_test; // average cost of education
  vector[N_tilde] POVERTY_RATE_test; // poverty rate in school area
  vector[N_tilde] URBAN_test; // urban dummy
  vector[N_tilde] PRIVATE_test; // private innstitution dummy
  vector[N_tilde] y_test; // median earnings

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

  // regression model parameters
  vector[K] alpha;
  vector[K] beta_SAT_ALL;
  vector[K] beta_MD_FAMINIC;
  vector[K] beta_COSTT4_A;
  vector[K] beta_POVERTY_RATE;
  vector[K] beta_URBAN;
  vector[K] beta_PRIVATE;
  vector<lower=0>[K] sigma;

}

model {

  // priors
  for (j in 1:K) {
    alpha[j] ~ normal(pm_alpha, ps_alpha);
    beta_SAT_ALL[j] ~ normal(pm_SAT_ALL, ps_SAT_ALL);
    beta_MD_FAMINIC[j] ~ normal(pm_MD_FAMINC, ps_MD_FAMINC);
    beta_COSTT4_A[j] ~ normal(pm_COSTT4_A, ps_COSTT4_A);
    beta_POVERTY_RATE[j] ~ normal(pm_POVERTY_RATE, ps_POVERTY_RATE);
    beta_URBAN[j] ~ normal(pm_URBAN, ps_URBAN);
    beta_PRIVATE[j] ~ normal(pm_PRIVATE, ps_PRIVATE);
    sigma[j] ~ normal(pm_sigma, ps_sigma);
  }


  // likelihoods
  for (i in 1:N) {
    y[i] ~ normal(alpha[x[i]] + beta_SAT_ALL[x[i]] * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] *
    MD_FAMINIC[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] +
    beta_POVERTY_RATE[x[i]] * POVERTY_RATE[i] +
    beta_URBAN[x[i]] * URBAN[i] + beta_PRIVATE[x[i]] * PRIVATE[i], sigma);
  }

}

generated quantities {

  vector[N] log_lik;
  vector[N] y_rep;
  vector[N_tilde] y_tilde;
  vector[N_tilde] indiv_squared_errors;
  real <lower = 0> sum_of_squares;
  real <lower = 0> root_mean_squared_error;

  for (i in 1:N) {
    log_lik[i] = normal_lpdf(y[i] | alpha[x[i]] + beta_SAT_ALL[x[i]]
    * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]]
    * POVERTY_RATE[i] + beta_URBAN[x[i]] * URBAN[i] +
    beta_PRIVATE[x[i]] * PRIVATE[i], sigma[x[i]]);

    y_rep[i] = normal_rng(alpha[x[i]] + beta_SAT_ALL[x[i]]
    * SAT_ALL[i] + beta_MD_FAMINIC[x[i]] * MD_FAMINIC[i] + beta_COSTT4_A[x[i]] * COSTT4_A[i] + beta_POVERTY_RATE[x[i]]
    * POVERTY_RATE[i] + beta_URBAN[x[i]] * URBAN[i] +
    beta_PRIVATE[x[i]] * PRIVATE[i], sigma[x[i]]);
  }
  
  for (i in 1:N_tilde) {
   y_tilde[i] = normal_rng(alpha[x_tilde[i]] + beta_SAT_ALL[x_tilde[i]] * SAT_ALL_test[i]
    + beta_MD_FAMINIC[x_tilde[i]] * MD_FAMINIC_test[i]  + beta_COSTT4_A[x_tilde[i]] * COSTT4_A_test[i] + beta_POVERTY_RATE[x_tilde[i]] *
    POVERTY_RATE_test[i] + beta_URBAN[x_tilde[i]] * URBAN_test[i] + 
    beta_PRIVATE[x_tilde[i]] * PRIVATE_test[i], sigma);
    
   indiv_squared_errors[i] = (y_test[i] - y_tilde[i])^2;
   
 }
 
 sum_of_squares = sum(indiv_squared_errors);
 root_mean_squared_error = sqrt(sum_of_squares / N_tilde);

}
