clear;
close all;
V_min = 11;
V_max = 12;
K = 0.03; 
L = 1.2*10^-4;
J = 1.0*10^-5;
R = 0.2;
T_f = 0.09;
T_l_min = 0;
T_l_max = 3;
T_l_range = T_l_min:0.01:T_l_max;
j = 1;
N = size(T_l_range);

period = 30;
duty_cycle = 99;

for V = V_min:V_max
    for i = 1:N(:,2)
        T_l = T_l_range(1,i);
        output = sim('motor_current_speed', [0:0.0001:0.02]);
        t = output.tout;
        current = output.yout{1}.Values.Data;
        speed = output.yout{2}.Values.Data;
        figure(1)
        yyaxis left;
        plot(t,current);
        yyaxis right;
        plot(t,speed);

        current_SS(j, i) = current(length(current),1);
        speed_SS(j, i) = speed(length(speed),1);
        if (speed_SS(j, i) <= 0)
            break
        end
    end
    figure(2)
    hold on;
    plot(T_l_range(1,1:i), current_SS(j,:))
    title('Current vs Torque');
    xlabel('T (N/m)');
    ylabel('I (A)');
    figure(3)
    hold on;
    plot(T_l_range(1,1:i), speed_SS(j,:))
    title('Speed vs Torque');
    xlabel('T (N/m)');
    ylabel('w (rpm)');
    j = j+1;
end


