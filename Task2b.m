clear;
close all;
V = 12;
T_l_min = 0;
T_l_max = 3;
T_l_range = T_l_min:0.01:T_l_max;
N = size(T_l_range);

V = 12;
K = 0.277; 
L = 0.2*10^-4;
J = 1.0*10^-5;
R = 1.77;
T_f = 0.005;
period = 1700;
duty_cycle = 99;

Hs = struct([]);
for i = 1:N(:,2)
    T_l = T_l_range(1,i);
    
    if T_l == 0
        Hs(3).num = [-6732,1.395e10];
        Hs(3).den = [1,8.842e04,6.056e08];
        Hs(4).num = [0,0];
        Hs(4).den = [1,0,0];
    elseif T_l > 0 && T_l < 1
        Hs(3).num = [131.5,3.817e06];
        Hs(3).den = [1,5.091e04,2.16e08];
        Hs(4).num = [-6.895e05,2.621e11];
        Hs(4).den = [1,8.616e04,5.891e08];
    elseif T_l > 1 && T_l < 2.58
        Hs(3).num = [42.81,7.811e05];
        Hs(3).den = [1,6818,1.729e07];
        Hs(4).num = [-1.55e04,6.752e08];
        Hs(4).den = [1,3.358e04,2.201e08];
    else
        Hs(3).num = [0,0];
        Hs(3).den = [1,0,0];
        Hs(4).num = [0,0];
        Hs(4).den = [1,0,0];
    end
    
    output = sim('dc_motor_from_idtf', [0:0.000001:0.002]);
%   output = sim('task2_motor_current_speed', [0:0.000001:0.003]);
    t = output.tout;
    current = output.yout{1}.Values.Data;
    speed = output.yout{2}.Values.Data;
    torque = output.yout{3}.Values.Data;
    figure(1)
    yyaxis left;
    plot(t,current);
    yyaxis right;
    plot(t,speed);

    current_SS(1, i) = current(length(current),1);
    speed_SS(1, i) = speed(length(speed),1);
    efficiency(1, i) = 100*(T_l*speed_SS(1, i)/9.5493)/(V*current_SS(1, i));
    if (speed_SS(1, i) <= 0)
        break
    end
end
figure(2)
hold on;
plot(T_l_range(1,1:i), current_SS(1,:))
title('Current vs Torque');
xlabel('T (Nm)');
ylabel('I (A)');
figure(3)
hold on;
plot(T_l_range(1,1:i), speed_SS(1,:))
title('Speed vs Torque');
xlabel('T (Nm)');
ylabel('w (rpm)');
figure(4)
hold on;
plot(T_l_range(1,1:i), efficiency(1, :))
title('Efficiency vs Torque');
xlabel('T (Nm)');
ylabel('Eff (%)');