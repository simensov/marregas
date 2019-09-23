% Answers task 3 in Assignment 3 in TMR4240, Fall 2019
%
% Author: Simen Oevereng

%%% Define rudder angle / ship heading transfer function with given constants
K = 1; T = 1;
P = tf([K],[T 1 0]);

%%% Continous-time domain controller transfer function
G = 4*tf([1 1],[1 2]);

%%% Define the cont. CL system and simplify.
system = G * P;
system_fb = feedback(system,1);
system_minreal = minreal(system_fb);

%%% Calculations of damping and natural frequency

[wn,zeta,p] = damp(system_minreal);

%%% Discretizing controller using ZOH, Tustin, and f-Euler with unknown h
% (done by setting ts = -1 in tf('z',ts)

% A good sampling period for the system (discussed in deliverable)
h = 0.125;

% These calculations are shown in the deliverable following this assignment
d_G_euler = tf([4, 4*(T-1)],[1, (2*T-1)],h,'Variable','z');
d_G_tustin = tf([ (4+2*T), (2*T-4)],[(1+T), (T-1)],h,'Variable','z');
d_G_ZOH = tf([ (4), (2-2*exp(-2*T)-4)],[(1), (-exp(-2*T))],h,'Variable','z');

% Alternative to these hand made discretized transfer functions from c2d()
G_c2d_zoh        = c2d(G,h,'zoh');
G_c2d_tustin     = c2d(G,h,'tustin');

% Discretize the system through zoh, and find closed loop system to simulate
d_P   = c2d(P,h,'zoh');

d_sys_zoh = feedback((d_P*G_c2d_zoh),1);
d_sys_tustin = feedback((d_P*G_c2d_tustin),1);
d_sys_euler = minreal(feedback((d_P*d_G_euler),1));

plotTime = 14;

% Plot 1 - different controllers vs real
figure;
hold on;
step(system_minreal,plotTime);
step(d_sys_zoh,plotTime);
step(d_sys_tustin,plotTime);
step(d_sys_euler,plotTime);
legend('Continuous','Zero-Order-Hold','Tustin','Forward Euler');
title(strcat('Step response with continous and discrete controllers, h = ',strcat(num2str(h),' s')));
xlabel('Time');
ylabel('Response');
hold off

%%% Plot 2 - step response with the use of three different sampling periods
sP = [0.1,0.25,0.5]; % sampling periods in [s]

discmethod = 'zoh';
figure;
grid on
hold on  
for method=1:length(sP)*3    
    if method == 4
       discmethod = 'tustin';
       figure;
       grid on
       hold on 
    elseif method == 7
       discmethod = 'euler';
       figure;
       grid on
       hold on 
    end
    
    step(system_minreal,plotTime);
    for i=1:length(sP)
        d_P   = c2d(P,sP(i),'zoh');
        if strcmp(discmethod,'euler')
            d_G = tf([4, 4*(T-1)],[1, (2*T-1)],sP(i),'Variable','z');
        else
            tic
            d_G = c2d(G,sP(i),discmethod);
            toc
        end
        d_sys = feedback(d_P*d_G, 1);
        step(d_sys,plotTime);
    end
    disp(discmethod);
    title(strcat('Step response with different sampling periods using',{' '},discmethod,' method'));
    xlabel('Time');
    ylabel('Response');
end
hold off


