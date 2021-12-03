clear;
close all;
V = 12;
K = 0.397; 
L = 0.2*10^-4;
J = 1.3*10^-5;
R = 1.77;
T_f = 0.115;
T_l_min = 0.05;
T_l_max = 0.2;
T_l_range = T_l_min:0.01:T_l_max;
N = size(T_l_range);
period = 1/20;

std_params = 0.1;
% • Resistance: lognormal, mu=0.1, sigma=0.05*mu;
% • Inductance: lognormal, mu=1.0e-4, sigma=0.05*mu; 
% • Inertia: lognormal, mu=9.0e-5, sigma=0.05*mu; 
% • Torque (Back emf) gain: lognormal, mu=0.02, sigma=0.05*mu;
% • Load: from 0.05 Nm to 0.2 Nm, uniform distribution;
% • Battery voltage: from 10 v to 16 v; uniform distribution;
% • Duty cycle: 20%;

n = 10;
y = zeros(n,1);
inc_V = (16-10)/n;
y(:,1) = random('Lognormal', log(R), std_params*R, [n,1]);
y(:,2) = random('Lognormal', log(L), std_params*L, [n,1]);
y(:,3) = random('Lognormal', log(J), std_params*J, [n,1]);
y(:,4) = random('Lognormal', log(K), std_params*K, [n,1]);
% y(:,5) = transpose(0.05: 0.001: 0.2); %T_l_range
y(:,5) = transpose(10: inc_V: 16-inc_V); %V
y(:,6) = 20*ones(n,1); %dutyCycle

for j=1:n
    R = y(j,1);
    L = y(j,2);
    J = y(j,3);
    K = y(j,4);
    V = y(j,5);
    duty_cycle = y(j,6);
    for k = 1:N(:,2)
        T_l = T_l_range(1,k);
        output = sim('motor_current_speed', [0:0.0001:0.002]);
        t = output.tout;
        current = output.yout{1}.Values.Data;
        speed = output.yout{2}.Values.Data;
        figure(1)
        yyaxis left;
        plot(t,current);
        yyaxis right;
        plot(t,speed);
    
%         t_steady_state_range = (t >= 0.001) & (t <= 0.002);
%         current_SS(1, i) = mean(current(t_steady_state_range));
%         speed_SS(1, i) = mean(speed(t_steady_state_range));
%         efficiency(1, i) = 100*(T_l*speed_SS(1, i)/9.5493)/(V*current_SS(1, i));
%         if (speed_SS(1, i) <= 0)
%             break
%         end
        j
        k
    end
end
% std_efficiency = std(efficiency);

%now reduce this std of efficiency by 50%

Cost = 7 * 1/std_params



