% Use transfer funtions from
% https://stanford.edu/~boyd/ee102/conv_demo.pdf

close all

uclr = [1 0.3 0.3];
oclr = [0.3 0.3 1];
rclr = [0.2 0.8 0.3];

lw = 1.5;


sin02plussin1 = out.sin02.Data + out.sin1.Data;

figure;
subplot(2,1,1)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_lowpass.Time, out.u_lowpass.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin1.Time, sin02plussin1,'Color',rclr,'LineWidth',lw);
grid on
title('Lowpass cutoff 1Hz')
legend(p,'u','u lowpass','sin(0.2t)+sin(t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p

subplot(2,1,2)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_lowpass_2.Time, out.u_lowpass_2.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin02.Time, out.sin02.Data,'Color',rclr,'LineWidth',lw);
grid on
title('Lowpass cutoff 0.2 Hz')
legend(p,'u','u lowpass','sin(0.2t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p

figure;
subplot(2,1,1)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_highpass.Time, out.u_highpass.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin10.Time, out.sin10.Data,'Color',rclr,'LineWidth',lw);
grid on
title('Highpass cutoff 10 Hz')
legend(p,'u','u highpass','sin(10t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p

sin1plussin10 = out.sin1.Data + out.sin10.Data;

subplot(2,1,2)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_highpass_2.Time, out.u_highpass_2.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin1.Time, sin1plussin10,'Color',rclr,'LineWidth',lw);
grid on
title('Highpass cutoff 0.2 Hz')
legend(p,'u','u highpass','sin(t)+sin(10t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p

sin02plus10 = out.sin02.Data + out.sin10.Data;

figure;
subplot(2,1,1)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_notch.Time, out.u_notch.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin02.Time, sin02plus10,'Color',rclr,'LineWidth',lw);
grid on
title('Notch removing 1 Hz')
legend(p,'u','u notch','sin(0.2t)+sin(10t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p

subplot(2,1,2)
p(1) = plot(out.u.Time, out.u.Data,'Color',uclr,'LineWidth',lw);
hold on
p(2) = plot(out.u_cascade.Time, out.u_cascade.Data,'Color',oclr,'LineWidth',lw);
hold on
p(3) = plot(out.sin1.Time, out.sin1.Data,'Color',rclr,'LineWidth',lw);
grid on
title('Cascade keeping 1 Hz')
legend(p,'u','u cascade','sin(t)')
xlabel('Time [s]')
ylabel('Amplitude of signal')
clear p