
% Stepsize and max time
tspan = 20;

% Initialize input and response before the input kicks in
u = [0 ones(1,tspan-1)];
y = zeros(1,4);

% Plot response after u has kicked in
for k = 5:tspan-3
    y(k) = 0.5*y(k-1) + u(k-3) + 0.2*u(k-4);
end

% Plot rest of the y's -> k is now on the last input time
for i = k:tspan
    y(i) = y(i-1);
end

% i is now on the last response
% Plot response, input and the asymptote
figure;
p(1) = plot(0:tspan-1,y,'-r');
hold on
p(2) = plot(0:tspan-1,u,'-b');
title('')
p(3) = plot(0:tspan-1,ones(1,tspan).*y(i),'--b');
legend(p,'Response','Input','Converged value')
title('Response of task 3')
xlabel('Time step')
ylabel('Response')