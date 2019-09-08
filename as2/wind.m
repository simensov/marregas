% Using wind 

k = 0.003;
z_0 = 10 * exp(-2 / (5 * sqrt(k)));
U_mean_10 = 12;
mu = 0.001
h = 1;
w = 0.005;

% \dot U_SV(z) + mu * U_SV = w

z = 3;
t_range = 0:1000;

