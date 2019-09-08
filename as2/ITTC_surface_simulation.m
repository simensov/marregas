% Plots surface elevation for the given ITTC spectra

H_significant = 2.5;
T_peak        = 9.0;
omega_peak    = 2.0 * pi / T_peak;
omega_low     = 0.2;
omega_high    = 3.0 * omega_peak;
g_accel = 9.81;
PLT_NUM = 150;
dw      = (omega_high - omega_low) / PLT_NUM;
w_range = omega_low:dw:omega_high;
h_max = 1000;
h_range = 0:h_max;
dt = 0.1;
t_range = 0:dt:60;

% Get amplitudes from ITTC spectra
A = 0.31 * H_significant^2 * omega_peak^4;
B = 1.25 * omega_peak^4;
ampl = zeros(1,length(w_range));

% Create all random variables and wave numbers in the same loop
phi = zeros(1,length(w_range));
k = zeros(1,length(w_range));

for j = 1:length(w_range)
    S = (A / w_range(j)^5) * exp(-B / w_range(j)^4);
    ampl(j) = sqrt(2 * S * dw); 
    phi(j) = unifrnd(0,2*pi);
    k(j) = w_range(j)^2 / g_accel;
end

fig = figure;
grid on
axis([0 h_max -5 5])
set(gca,'nextplot','replacechildren');

% Pre-allocating surface elevation per wave component
z_j = zeros(1,length(w_range)); 
z = zeros(1,length(h_range));

% For each time instance, go through wave elevation for all x-values, and
% calculate elevation per frequency component
for tC = 1:length(t_range)
    t = t_range(tC);
    
    for i = 1:length(h_range)
        for j = 1:length(w_range)
            z_j(j) = ampl(j) * cos(w_range(j) * t - k(j) * h_range(i) + phi(j));
        end
        z(i) = sum(z_j);
    end
    plot(h_range,z);
    text(h_max/2.5,H_significant*1.2,sprintf('time = %.2f s',t));
    F(tC) = getframe(fig);
    % pause(0.05);
end
    
% movie(F,1,1);

movie2gif(F,'elevation.gif','DelayTime', 0);