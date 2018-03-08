data {
    int<lower=1> N;
    int<lower=1> G;
    int<lower=1, upper=G>  group_id[N]; 
    vector[N] milk;
}

transformed data {
    vector[N] centered_milk;
    centered_milk = (milk - mean(milk))/sd(milk);
}

parameters {
    real mu_std[G];
    real<lower=0> sigma_std[G];
}


model {
    mu ~ normal(0, 1)
    sigma_std ~ student_t(1, 0, 1)
    /**
    * Slower but equivalent part.
    * for(i in 1:G) {
    *     sigma_std[i] ~ student_t(1, 0, 1)
    * }
    **/

    for(i in 1:N) {
       centered_milk[i] ~ normal(mu_std[gid[i]], sigma[gid[i]]);
    }
        
}

generated quantities {
   real mu[G];
   real<lower=0> sigma[G};
   mu = mean(milk) + mu_std*sd(milk);
   sigma = sd(milk)*sigma_std;
  
}
