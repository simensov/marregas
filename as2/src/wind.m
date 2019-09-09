% Using wind 

% a) Mean wind variations
k = 0.003;
z_0 = 10 * exp(-2 / (5 * sqrt(k)));
U_mean_10 = 12;
my = 0.001;
h = 1;
w = 0.005; % power [W]
w_dB = 6.99; % power [dBW]

z = 3;
t_max = 1000;
t_range = 0:h:t_max-1;

% Wind components must be the sum of the mean and the random variations
U_mean = U_mean_10 * 2.5 * sqrt(k) * log(z/z_0) * zeros(1,length(t_range));

sim('mean_wind_fluctuations.slx'); % Outputs mean wind fluctuations, adding variable U_fl to the workspace

U_m_fl = U_mean + U_fl.Data';

ax = gca;
improveFigFit(ax);

plot(t_range,U_m_fl,'b');
hold on
plot(t_range,U_mean,'r');
hold off
xlabel('Time [s]','FontSize',14);
ylabel(sprintf('Wind speed [m/s]',z),'FontSize',14);
title('Mean wind fluctuations at 3 meters height','FontSize',14);
legend('Mean wind fluctuation','Mean wind');

% --------- % b) Gust

% The wind spectras has almost no energy above 1 Hz
% Choosing the NORSOK spectra, a lower bound is chosen at 1E-4.

df = 10^(-4);
f_range = df:df:1;
% f_range = logspace(-4,0);           % Frequencies distributed logaritmically
phi = 2*pi*rand(1,length(f_range)); % Random phase angles

U_g = zeros(1,length(t_range));  % Gust components at each time step
U_gi = zeros(1,length(f_range)); % Gust component from each f value

for t = 1:length(t_range)
    for i = 1:length(f_range)-1
        f_i = f_range(i);
        % df = (f_range(i+1)-f_range(i)) / length(f_range); % varying b/c logspace
        U_gi(i) = sqrt(2 * NORSOK(f_i,z) * df) * cos(2 * pi * f_i * t + phi(i));
    end
    U_g(t) = sum(U_gi);
end

figure;
plot(t_range,U_g);
xlabel('Time [s]','FontSize',14);
ylabel(sprintf('Wind speed [m/s]',z),'FontSize',14);
title('Wind gust','FontSize',14);

% Total wind speeds
U_tot = U_m_fl + U_g;

figure;
plot(t_range,U_tot);
xlabel('Time [s]','FontSize',14);
ylabel(sprintf('Wind speed [m/s]',z),'FontSize',14);
title('Total wind speed','FontSize',14);


