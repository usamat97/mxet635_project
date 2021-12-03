clear;
close all;

V = 12;
K = 0.397; 
L = 0.2*10^-4;
J = 1.3*10^-5;
R = 1.77;
T_f = 0.115;
% duty_cycle = 50; %percentage
% frequency = 200; %hertz
% period = 1/frequency;
T_l_min = 0;
T_l_max = 3;
T_l_range = T_l_min:0.01:T_l_max;
N = size(T_l_range); 

for j = 1:2
    if j == 1
        duty_cycle = 50;
        frequency = 900;
        period = 1/frequency;
    else
        duty_cycle = 99;
        frequency = 0.2;
        period = 1/frequency;
    end
    for i = 1:N(:,2)
        T_l = T_l_range(1,i);
        output = sim('motor_current_speed', [0:0.00001:0.05]);
        t = output.tout;
        current = output.yout{1}.Values.Data;
        speed = output.yout{2}.Values.Data;
        if j == 1
            figure(1)
            plot(t,speed)
            t_steady_state_range = (t >= (0.05 - period)) & (t <= 0.05);
            current_SS(1, i) = mean(current(t_steady_state_range));
            speed_SS(1, i) = mean(speed(t_steady_state_range));
        else
            figure(2)
            plot(t,speed)
            current_SS(1, i) = current(length(current),1);
            speed_SS(1, i) = speed(length(speed),1);
        end
        if (speed_SS(1, i) <= 0)
            break
        end
    end
    figure(3)
    hold on;
    plot(T_l_range(1,1:i), current_SS(1,:))
    title('Current vs Torque');
    xlabel('T (Nm)');
    ylabel('I (A)');
    if j == 2
        legend('PWM','Constant Voltage')
    end
    figure(4)
    hold on;
    plot(T_l_range(1,1:i), speed_SS(1,:))
    title('Speed vs Torque');
    xlabel('T (Nm)');
    ylabel('w (rpm)');
    if j == 2
        legend('PWM','Constant Voltage')
    end
end