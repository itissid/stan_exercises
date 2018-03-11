data {
    int<lower=1> N;
    int<lower=1> G;
    int<lower=1, upper=G>  group_id[N]; 
    vector[N] milk;
}

transformed data {
    real milk_mean[G] = rep_array(0.0, G);
    real milk_var[G] = rep_array(0.0, G);
    int group_pop[G] = rep_array(0, G);
    vector[N] centered_milk;
    for(n in 1:N) {
        group_pop[group_id[n]] += 1;
    }

    for(n in 1:N) {
        milk_mean[group_id[n]] += milk[n]/group_pop[group_id[n]];
    }

    for(n in 1:N) {
        milk_var[group_id[n]] += ((milk[n] - milk_mean[group_id[n]])^2)/group_pop[group_id[n]];
    }

    for(n in 1:N) {
        centered_milk[n] = (milk[n] - milk_mean[group_id[n]])/sqrt(milk_var[group_id[n]]);
	print(centered_milk[n]);
    }
    print(milk_mean);
    print(milk_var);
}

parameters {
    real mu_std[G];
    real<lower=0> sigma_std[G];
}


model {
    mu_std ~ normal(0, 1);
    sigma_std ~ student_t(1, 0, 1);
    /**
    * Slower but equivalent part.
    * for(i in 1:G) {
    *     sigma_std[i] ~ student_t(1, 0, 1)
    * }
    **/

    /**for(i in 1:N) {
     *  centered_milk[i] ~ normal(mu_std[group_id[i]], sigma_std[group_id[i]]);
     * }
    **/

     centered_milk ~ normal(mu_std[group_id], sigma_std[group_id]);
        
}

generated quantities {
    real mu[G];
    real<lower=0> sigma[G];
    // For each group reverse the transform the standardized parameters into
    // ones that conform to the scale of the data.
    for(g in 1:G) {
       mu[g] = milk_mean[g] + mu_std[g]*sqrt(milk_var[g]);
       sigma[g] = sqrt(milk_var[g])*sigma_std[g];
    }
}
