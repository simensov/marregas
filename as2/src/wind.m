% Using wind 

%% a) Mean wind variations
k = 0.003;
z_0 = 10 * exp(-2 / (5 * sqrt(k)));
U_mean_10 = 12;
mu = 0.001;
h = 1;
w = 0.005; % power [W]
w_dB = 6.99; % power [dBW]

z = 3;
t_max = 1000;
t_range = 0:h:t_max;

% Wind components must be the sum of the mean and the random variations

U_mean = U_mean_10 * 2.5 * sqrt(k) * log(z/z_0);
w_rand = w * randn(1,length(t_range)); % random about zero
% random_noise = wgn(length(t_range),1,w_dB); % row vector of noise

% \dot y = w - my * U_SV = f TODO NEEDS SATURATION
[tv yv] = ode45(@(t,y) (U_mean + w_dB * randn() - mu * y),t_range,U_mean);

% Attempts to solve with saturation, but only returns a continous solution
% syms y(t) P K V a t u0
% % dy(t)/dt = P - K(y(t)/(V-at)) - a(y(t)/(V-at))
% % y(0) = 18
% assume( y(t) < 20);
% assumeAlso( y(t) > -20 );
% func = ( diff(y) == w_dB * randn() - mu * y(t) );
% sol = dsolve(func, y(0) == 0);
% sol = simplify(sol);

% for t = 1:length(t_range)
%     ss(t) = 4747.51*exp(-t/1000) - 4747.51; % found from snippet above
% end

% figure;
% subplot(2,1,1);
% plot(tv,yv);
% title('Mean wind');

%% b) Gust

% The wind spectras has almost no energy above 1 Hz
% Choosing the NORSOK spectra, a lower bound is chosen at 1E-4.

f_range = logspace(-6,0);

for j = 1:length(f_range)
    phi(j) = unifrnd(0,2*pi);
end

U_g = zeros(1,length(t_range));
U_gi = zeros(1,length(f_range));

for t = 1:length(t_range)
    for i = 1:length(f_range)-1
        f_i = f_range(i);
        df = (f_range(i+1) - f_range(i)) / length(f_range); % varying due to logspace
        U_gi(i) = sqrt(2 * NORSOK(f_i,z) * df ) * cos(2 * pi * f_i * t + phi(i));
    end
    U_g(t) = sum(U_gi);
end


ax = gca;
improveFigFit(ax);

plot(t_range,U_g);
xlabel('Time [s]','FontSize',14);
ylabel(sprintf('Wind speed at %d meters height [m/s]',z),'FontSize',14);
title('Wind gust','FontSize',14);

%%

% Function implementations
function S = NORSOK(f,z)
    U_mean_10 = 12;
    n = 0.468;
    x = 172 * f * (z/10)^(2/3) * (U_mean_10/10)^(-3/4);
    S = 320 * (U_mean_10/10)^2 * (z/10)^0.45 / (1+x^n)^(5/(3*n));
end
