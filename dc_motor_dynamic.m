clear;
close all;

K = 0.02; 
L = 1.0*10^-4;
J = 9.025*10^-5;
R = 0.1;
T_f = 0.07;
V = 12;
duty_cycle = 20; %percentage
frequency = 200; %hertz
period = 1/frequency;
T_l = 0.1;
T_l_min = 0;
T_l_max = 3;
T_l_range = T_l_min:0.01:T_l_max;
N = size(T_l_min:0.01:T_l_max); 

for i = 1:N(:,2)
    T_l = T_l_range(1,i);
    output = sim('motor_current_speed', [0:0.0001:1.2]);
    t = output.tout;
    current = output.yout{1}.Values.Data;
    speed = output.yout{2}.Values.Data;
    current_SS(1, i) = mean(current(length(current)-frequency : length(current), 1));
    speed_SS(1, i) = mean(speed(length(speed)-frequency : length(speed), 1));
    if (speed_SS(1, i) <= 0)
        break
    end
end
figure(1)
hold on;
plot(T_l_range(1,1:i), current_SS(1,:))
title('Current vs Torque');
xlabel('T (N/m)');
ylabel('I (A)');
figure(2)
hold on;
plot(T_l_range(1,1:i), speed_SS(1,:))
title('Speed vs Torque');
xlabel('T (N/m)');
ylabel('w (rpm)');


