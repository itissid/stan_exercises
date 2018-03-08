data {
    int N;
    int eggs[N];
}

parameters {
    real<lower=0> lambda;
}

model {
    target += normal_lpdf(lambda| 0, 1);
    target += poisson_lpmf(eggs| lambda); 
}
