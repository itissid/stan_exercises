data {
    int N;
    vector[N] x;
    vector[N] y;
}

transformed data{
    vector[N] x_c;
    vector[N] y_c;
    x_c = (x - mean(x))/sd(x);
    y_c = (y - mean(y))/sd(y);
}

parameters {
    real a;
    real b;
    real<lower=0> sigma;
}

model {
    target += normal_lpdf(sigma|0, 1); // modelling a unknown variance, t should be ok.
    target += normal_lpdf(a|0, 1); // a ~ normal(0,1)
    target += normal_lpdf(b|0, 1); // b ~ normal(0,1)
    target += normal_lpdf(y_c|a+b*x_c, sigma); // y ~ normal(a+bx, sigma)
}

