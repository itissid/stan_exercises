data {
    int N;
    vector[N] milk;
}

transformed data {
    vector[N] centered_milk;
    centered_milk = (milk - mean(milk))/sd(milk);
}

parameters {
    real mu_std;
    real<lower=0> sigma_std;
}


model {
    target += student_t_lpdf(sigma_std| 1, 0, 1); // modelling a unknown variance, t should be ok.
    target += normal_lpdf(mu_std|0, 1);
    target += normal_lpdf(centered_milk| mu_std, sigma_std);
}

generated quantities {
   // See page 362 of stan manual for this piece of code
   real mu;
   real<lower=0> sigma;
   mu = mean(milk) + mu_std*sd(milk);
   sigma = sd(milk)*sigma_std;
  
}
