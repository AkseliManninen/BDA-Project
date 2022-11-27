data {

  // number of observations
  int<lower=0> N;

  // number of regions
  int<lower=0> K;

  // region indicators
  array[N] int<lower=1, upper=K> x;

  // data vectors
  matrix[N,K] SAT_ALL; // composite SAT score
  vector[N] y; // dependent variable (median earnings 10 years post-graduation)

  // prior parameters
  real pm_alpha; // prior mean of intercept term
  real ps_alpha; // prior sd of intercept term
  real pm_SAT_ALL;
  real ps_SAT_ALL;
  real pm_sigma;
  real ps_sigma;

}

parameters {

  vector[K] alpha;
  vector[K] beta_SAT_ALL;
  vector<lower=0>[K] sigma;

}

model {

  // weakly informative prior distributions
  for (j in 1:K) {
    alpha[j] ~ normal(pm_alpha, ps_alpha);
    beta_SAT_ALL[j] ~ normal(pm_SAT_ALL, ps_SAT_ALL);
  }


  // likelihoods
  for (j in 1:K) {
    y ~ normal(alpha[j] + beta_SAT_ALL[j] * SAT_ALL[,j], sigma);
  }

}

generated quantities {
  vector[N] log_lik; // to do
}
