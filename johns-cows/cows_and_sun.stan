data {
    int N;
    vector[N] x;
    vector[N] y;
}


parameters {
    real a;
    real b;
    real<lower=0> sigma;
}


model {
    target += student_t_lpdf(sigma| 1, 0, 1); // modelling a unknown variance, t should be ok.
    target += normal_lpdf(a|0, 10); // a ~ normal(0,1)
    target += normal_lpdf(b|0, 10); // b ~ normal(0,1)
    target += normal_lpdf(y|a+b*x, sigma); // y ~ normal(a+bx, sigma)
}
