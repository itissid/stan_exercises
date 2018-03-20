functions {
    /**
    * Fibonacci series extended to real numbers
    *
    * See eq 10 of http://mathworld.wolfram.com/FibonacciNumber.html
    * but note we want the definition where F(0) = 1 rather than 
    * F(0) = 0 so, we have to plug nu + 1 into the function.
    *
    * @param nu Real number greater than -1
    * @param generalized Fibonacci number
    * Courtsey Ben Goodrich, Columbia University
    **/
    real F(real nu) {
        real sqrt_5 = sqrt(5.0); // need 5.0 rather than 5 to avoid error
        real half_sqrt5p1 = 0.5 * (1 + sqrt_5);
        real nu_p1 = nu + 1;
        return (half_sqrt5p1^nu_p1 - half_sqrt5p1^-nu_p1 *
                cos(nu_p1 * pi())) / sqrt_5;
    }
    /**
     * Logarithm of PMF for bowling with real shape parameter, gamma
     *
     * @param x integer(s) between 0 and 10
     * @param gamma real number greater than -1
     * @param n integer(s) between 0 and 10
     * @return log probability of x given gamma and n
     * Courtsey Ben Goodrich, Columbia University
    **/
    real bowling_frame_lpmf(int[] x, real gamma, int[] n) {
        int N = num_elements(x); real out = 0;
        real F_gamma_p1 = F(gamma + 1);
        if (gamma <= -1) reject("gamma must be greater than -1");
        if (num_elements(n) != N)
            reject("number of elements in x and n must match");
        for (i in 1:N) {
            int x_i = x[i]; 
            real n_i = n[i];
            if (x_i < 0 || x_i > 10)
                reject("all x must be between 0 and 10");
            if (n_i < 0 || n_i > 10)
                reject("all n must be between 0 and 10");
            out = out + (x_i > n_i ? negative_infinity() : log(
            F(x_i + gamma) / (F(n_i + gamma + 2) - F_gamma_p1) ));
        }
        return out;
    }
}

data {
    int<lower=0> nframes;
    int <lower=0, upper=10> x1[nframes]; 
    int <lower=0, upper=10> x2[nframes]; 
}


transformed data {
    int<lower=0, upper=10> ninit [nframes] = rep_array(10, nframes); 
    int<lower=0, upper=10> n_minus_x1 [nframes]; 
    for (i in  1:nframes) {
        n_minus_x1[i] = ninit[i] - x1[i];
    }
}
// We want a positive gamma
parameters {
   real<lower=0> gamma_p1;
}

transformed parameters {
    real<lower=-1> g = gamma_p1 - 1; // We want gamma - 1
}

model {
   target += gamma_lpdf(gamma_p1|  9, 2); // keeping rate and shape constant for now
   target += bowling_frame_lpmf(x1| g, ninit);
   target += bowling_frame_lpmf(x2| g, n_minus_x1);
}

