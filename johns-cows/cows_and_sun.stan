data {
    int N;
    vector[N] x;
    vector[N] y;
}

transformed data{
    vector[N] y_c;
    vector[N] x_c;
    y_c = (y - mean(y))/sd(y);
    x_c = (x - mean(x))/sd(x);
}

parameters {
    real a;
    real b;
    real<lower=0> sigma;
}

model {
    target += student_t_lpdf(sigma|1, 0, 1); // modelling a unknown variance, t should be ok.
    target += normal_lpdf(a|0, 1); // a ~ normal(0,1)
    target += normal_lpdf(b|0, 1); // b ~ normal(0,1)
    target += normal_lpdf(y_c|a+b*x_c, sigma); // y ~ normal(a+bx, sigma)
}
