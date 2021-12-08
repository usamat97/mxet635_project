clear;
close all;

K_0 = 0.397; 
L_0 = 0.2*10^-4;
J_0 = 0.0353077;
R_0 = 1.77;
T_f_0 = 0.119;
V_0 = 12;
duty_cycle_0 = 20; %percentage
T_l_min = 0;
T_l_max = 3;
T_l_range = T_l_min:0.2:T_l_max;
N_Tl = size(T_l_range);

error_duty_cycle = 0.25;
error_V = 0.375;
error = 0.2;

val = [K_0, L_0, J_0, R_0, T_f_0, duty_cycle_0, V_0];
err = [error, error, error, error, error, error_duty_cycle, error_V];
[M,N] = size(val);

frequency = 6; %hertz
period = 1/frequency;

param_matrix = zeros([2^(N),N]); 

DOE_matrix = [
    -1	1	1	1	1	1	-1
    1	-1	1	1	-1	1	-1
    -1	1	-1	-1	1	-1	1
    1	1	-1	1	1	-1	1
    1	-1	-1	1	-1	1	-1
    -1	-1	1	1	-1	-1	-1
    1	1	-1	1	1	-1	-1
    -1	1	-1	-1	-1	1	1
    1	1	1	1	-1	-1	1
    1	-1	1	1	1	1	1
    -1	-1	1	-1	1	1	1
    -1	1	-1	-1	-1	-1	-1
    -1	1	1	1	-1	1	-1
    1	-1	1	1	1	-1	1
    1	-1	-1	-1	-1	1	-1
    1	-1	1	1	1	1	-1
    -1	-1	1	1	1	-1	-1
    -1	-1	-1	1	-1	1	-1
    1	-1	1	-1	-1	-1	1
    1	1	-1	1	1	1	1
    1	1	-1	-1	-1	1	1
    1	-1	-1	-1	-1	-1	1
    1	1	-1	1	-1	-1	-1
    1	-1	1	-1	1	-1	1
    1	-1	-1	1	-1	-1	1
    1	1	1	1	1	-1	-1
    -1	-1	1	-1	-1	-1	1
    -1	-1	-1	1	-1	-1	-1
    1	-1	-1	1	1	-1	1
    -1	-1	1	1	-1	1	1
    -1	1	-1	-1	1	1	-1
    -1	1	1	1	1	-1	1
    1	1	-1	-1	1	1	-1
    1	1	-1	1	-1	-1	1
    -1	1	1	1	-1	1	1
    -1	1	-1	1	-1	-1	-1
    -1	1	1	-1	1	-1	-1
    1	1	1	1	-1	-1	-1
    -1	1	1	-1	-1	-1	-1
    1	1	-1	-1	-1	1	-1
    1	1	1	-1	1	-1	1
    1	-1	1	1	-1	-1	-1
    1	-1	-1	1	1	1	1
    -1	-1	1	-1	-1	1	-1
    1	1	1	-1	-1	1	1
    -1	1	1	1	1	-1	-1
    -1	-1	1	1	1	1	1
    -1	-1	-1	-1	-1	-1	1
    1	-1	1	-1	1	-1	-1
    -1	1	-1	1	1	1	-1
    1	1	1	1	1	1	-1
    1	1	-1	-1	1	-1	1
    1	-1	-1	-1	1	-1	1
    -1	-1	1	1	1	-1	1
    -1	-1	-1	-1	1	-1	1
    1	-1	-1	-1	1	1	1
    -1	1	-1	1	-1	1	-1
    -1	1	-1	1	1	1	1
    1	-1	1	-1	-1	1	-1
    1	-1	1	-1	-1	1	1
    -1	-1	-1	1	-1	-1	1
    -1	-1	1	1	-1	-1	1
    1	1	-1	-1	1	1	1
    -1	1	-1	1	1	-1	1
    1	-1	1	1	1	-1	-1
    -1	-1	1	-1	-1	1	1
    -1	1	-1	-1	-1	1	-1
    -1	-1	1	-1	-1	-1	-1
    -1	1	1	-1	-1	1	1
    1	1	-1	1	1	1	-1
    -1	-1	-1	-1	-1	-1	-1
    1	1	1	-1	-1	-1	1
    -1	-1	1	-1	1	1	-1
    1	-1	1	1	-1	1	1
    1	-1	-1	1	-1	-1	-1
    -1	1	1	1	1	1	1
    -1	1	1	-1	-1	1	-1
    1	-1	-1	1	1	1	-1
    1	-1	1	-1	1	1	-1
    1	1	1	1	-1	1	1
    1	-1	-1	-1	-1	1	1
    -1	-1	-1	1	1	-1	1
    -1	-1	-1	-1	1	1	-1
    1	-1	-1	1	1	-1	-1
    -1	1	1	-1	-1	-1	1
    -1	1	-1	-1	1	-1	-1
    1	1	1	1	-1	1	-1
    1	-1	1	1	-1	-1	1
    -1	-1	-1	1	1	1	-1
    -1	1	1	-1	1	1	-1
    -1	-1	1	1	1	1	-1
    1	-1	-1	1	-1	1	1
    -1	-1	1	-1	1	-1	1
    1	1	-1	-1	-1	-1	-1
    -1	1	-1	-1	1	1	1
    -1	1	-1	1	-1	-1	1
    -1	-1	-1	-1	1	1	1
    -1	-1	-1	1	-1	1	1
    1	1	-1	-1	1	-1	-1
    -1	-1	-1	-1	-1	1	-1
    1	1	-1	-1	-1	-1	1
    -1	1	-1	1	1	-1	-1
    1	1	1	-1	1	1	1
    -1	-1	-1	1	1	-1	-1
    1	1	-1	1	-1	1	-1
    1	-1	-1	-1	1	1	-1
    1	1	1	1	1	-1	1
    -1	1	-1	-1	-1	-1	1
    1	1	1	-1	1	1	-1
    1	-1	1	-1	1	1	1
    1	1	1	-1	-1	-1	-1
    -1	-1	1	1	-1	1	-1
    1	-1	1	-1	-1	-1	-1
    1	-1	-1	-1	-1	-1	-1
    -1	1	1	-1	1	1	1
    -1	-1	-1	-1	-1	1	1
    1	-1	-1	-1	1	-1	-1
    1	1	-1	1	-1	1	1
    -1	1	1	1	-1	-1	-1
    -1	-1	-1	-1	1	-1	-1
    -1	1	-1	1	-1	1	1
    -1	1	1	-1	1	-1	1
    1	1	1	-1	1	-1	-1
    -1	-1	-1	1	1	1	1
    1	1	1	-1	-1	1	-1
    1	1	1	1	1	1	1
    -1	1	1	1	-1	-1	1
    -1	-1	1	-1	1	-1	-1
 ];

for i=1:N
    for j=1:2^(N)
        if (DOE_matrix(j,i)==1)
            param_matrix(j,i)= val(i) + val(i)*err(i);
        else
            param_matrix(j,i)= val(i) - val(i)*err(i);
        end
    end
end


for i=1:2^(N)
    K = param_matrix(i,1); 
    L = param_matrix(i,2);
    J = param_matrix(i,3);
    R = param_matrix(i,4);
    T_f = param_matrix(i,5);
    duty_cycle = param_matrix(i,6);
    V = param_matrix(i,7);
    for j = 1:N_Tl(:,2)
        T_l = T_l_range(1,j);
        output = sim('motor_current_speed', [0:0.01:12]);
        t = output.tout;
        current = output.yout{1}.Values.Data;
        speed = output.yout{2}.Values.Data;
        
%         figure(1)
%         yyaxis left;
%         plot(t,current);
%         yyaxis right;
%         plot(t,speed);

    
        t_steady_state_range = (t >= (12 - period)) & (t <= 12);
        current_SS(1, j) = mean(current(t_steady_state_range));
        speed_SS(1, j) = mean(speed(t_steady_state_range));
        if (speed_SS(1, j) <= 0)
            break
        end
        efficiency(j, 1) = 100*(T_l*speed_SS(1, j)/9.5493)/(V*current_SS(1, j)); 
        max_efficiency(i,1) = max(efficiency(j, 1));
        
    end
end
