clear;
close all;
V_min = 0;
V_max = 24;
V = 0;
K = 0.03; 
L = 1.2*10^-4;
J = 1.0*10^-5;
R = 0.2;
T_f = 0.09;
T_l_min = 0;
T_l_max = 2;
i = 1;

for T_l = T_l_min:0.1:T_l_max
    output = sim('motor_current_speed', [0:0.0001:0.02]);
    t = output.tout;
    current = output.yout{1}.Values.Data;
    speed = output.yout{2}.Values.Data;
    figure(1)
    yyaxis left;
    plot(t,current);
    yyaxis right;
    plot(t,speed);

    %estimate value of 't' for which steady state is reached
    %and store the corresponding index at which it occurs in
    %the variable 'ss_index'
    ss_init = 0.01;
    ss_increment = 0.001;
    for ss_init=ss_init:ss_increment:0.1
        ss_index = find(t==ss_init);
        ss_inc = find(t==(ss_init + ss_increment));
        if isempty(current(ss_inc))
            fprintf('[T_load=%f] steady state reached at t=%f\n', T_l, ss_init)
            break
        end
    end

    current_SS(i) = current(ss_index);
    speed_SS(i) = speed(ss_index);
    if (speed_SS(i) <= 0)
        break
    end
    i = i+1;
    torque(i) = T_l;
end
figure(2)
plot(torque, current_SS)
figure(3)
plot(torque, speed_SS)


