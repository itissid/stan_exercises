data{
    int<lower=0> N;
    int<lower=0, upper=1> cow[N];
}

parameters {
    real<lower=0, upper=1> p;
}

model {
    target += beta_lpdf(p| 1, 1);
    target += bernoulli_lpmf(cow | p);
}


