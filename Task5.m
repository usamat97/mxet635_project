clear;
close all;

K_0 = 0.02; 
L_0 = 1.0*10^-4;
J_0 = 9.025*10^-5;
R_0 = 0.1;
T_f_0 = 0.07;
V_0 = 12;
duty_cycle_0 = 20; %percentage
error = 0.2;
val = [K_0, L_0, J_0, R_0, T_f_0, V_0, duty_cycle_0];
[M,N] = size(val);
% error = [error_M0, error_B0, error_K0];
frequency = 200; %hertz
period = 1/frequency;

param_matrix = zeros([2^(N-3),N]); %1/8 design

DOE_matrix = [
    -1	-1	1	1	1	-1	-1
    1	1	1	1	1	1	1
    1	-1	1	1	-1	-1	1
    1	1	1	-1	1	-1	-1
    -1	1	-1	1	1	-1	1
    1	-1	-1	-1	1	-1	1
    -1	1	1	-1	-1	-1	1
    1	-1	-1	1	1	1	-1
    -1	-1	-1	-1	-1	-1	-1
    1	-1	1	-1	-1	1	-1
    -1	1	-1	-1	1	1	-1
    -1	-1	1	-1	1	1	1
    -1	1	1	1	-1	1	-1
    1	1	-1	1	-1	-1	-1
    1	1	-1	-1	-1	1	1
    -1	-1	-1	1	-1	1	1
 ];

for i=1:N
    for j=1:2^(N-3)
        if (DOE_matrix(j,i)==1)
            param_matrix(j,i)= val(i) + val(i)*error;
        else
            param_matrix(j,i)= val(i) - val(i)*error;
        end
    end
end


for i=1:2^(N-3)
    K = param_matrix(i,1); 
    L = param_matrix(i,2);
    J = param_matrix(i,3);
    R = param_matrix(i,4);
    T_f = param_matrix(i,5);
    V = param_matrix(i,6);
    duty_cycle = param_matrix(i,7); %percentage
    
    T_l_range = 0:0.01:3;
    sz_T_l = size(T_l_range);
    for j = 1:sz_T_l(:,2)
        T_l = T_l_range(1,j);
        output = sim('motor_current_speed', [0:0.001:1.2]);
        t = output.tout;
        current = output.yout{1}.Values.Data;
        speed = output.yout{2}.Values.Data;
%         current_SS(1, j) = mean(current(length(current)-frequency : length(current), 1))
        speed_SS(i, j) = mean(speed(length(speed)-frequency : length(speed), 1));
        if (speed_SS(i, j) <= 0)
            break
        end
    end
end
