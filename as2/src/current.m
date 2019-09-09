% Current

%% a) Written answer

%% b) Current profile
U_mean_10 = 12;

depth = 200;
reference = 50;
V_c_tide = 0.5;
V_c_wind = 0.015 * U_mean_10;

h_range = 0:depth;
V = zeros(1,length(h_range));
Vt = zeros(1,length(h_range));
Vw = zeros(1,length(h_range));
for z = 1:length(h_range)
    Vt(z) = V_c_tide * (abs(depth-z) / depth)^(1/7);
    if z <= reference
        Vw(z) = V_c_wind * ((reference-z) / reference)^(1/7);
    else
        Vw(z) = 0.0;
    end
    V(z) = abs(Vt(z) + Vw(z));
end

ax = gca;
improveFigFit(ax);
plot(V,-h_range)
hold on
plot(Vt,-h_range,'--')
hold on
plot(Vw,-h_range,'o')
legend('Current profile','Tide genereted profile','Wind generated profile')
xlabel('Speed [m/s]','FontSize',14);
ylabel('Depth [m]','FontSize',14);
title('Combined current profile','FontSize',14);
    