% Returns the spectral density of a freqency [Hz] at a certain elevation
% [m]
function S = NORSOK(f,z)
    U_mean_10 = 12;
    n = 0.468;
    x = 172 * f * (z/10)^(2/3) * (U_mean_10/10)^(-3/4);
    S = 320 * (U_mean_10/10)^2 * (z/10)^0.45 / (1+x^n)^(5/(3*n));
end