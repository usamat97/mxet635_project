clear;
close all;
V = 12;
K = 0.397; 
L = 0.2*10^-4;
J = 0.0353077;
R = 1.77;
T_f = 0.119;
T_l_min = 0.05;
T_l_max = 0.2;
V_max = 16;
V_min = 10;
period = 1/20;

std_params = 0.1;
half_std = 0;
i=1;
while std_params >= 0.0100
    n = 10;
    y = zeros(n,1);
    inc_V = (V_max-V_min)/n;
    
    y(:,1) = random('Lognormal', log(R), std_params*R, [n,1]);
    y(:,2) = random('Lognormal', log(L), std_params*L, [n,1]);
    y(:,3) = random('Lognormal', log(J), std_params*J, [n,1]);
    y(:,4) = random('Lognormal', log(K), std_params*K, [n,1]);
    y(:,5) = transpose(V_min: inc_V: V_max-inc_V); %V
    y(:,6) = 20*ones(n,1); %dutyCycle
    
    V_max = V_max *(1-std_params);
    V_min = V_min *(1+std_params);
    
    T_l_max = T_l_max *(1-std_params);
    T_l_min = T_l_min *(1+std_params);
    T_l_range = T_l_min:0.01:T_l_max;
    N = size(T_l_range);
    
    for j=1:n
        R = y(j,1);
        L = y(j,2);
        J = y(j,3);
        K = y(j,4);
        V = y(j,5);
        duty_cycle = y(j,6);
        for k = 1:N(:,2)
            T_l = T_l_range(1,k);
            output = sim('motor_current_speed', [0:0.01:12]);
            t = output.tout;
            current = output.yout{1}.Values.Data;
            speed = output.yout{2}.Values.Data;
            figure(1)
            yyaxis left;
            plot(t,current);
            yyaxis right;
            plot(t,speed);

            t_steady_state_range = (t >= (12 - period)) & (t <= 12);
            current_SS(1, j) = mean(current(t_steady_state_range));
            speed_SS(1, j) = mean(speed(t_steady_state_range));
            efficiency(1, j) = 100*(T_l*speed_SS(1, j)/9.5493)/(V*current_SS(1, j));
            max_eff(j) = max(efficiency);
            if (speed_SS(1, j) <= 0)
                break
            end
        end
    end
std_efficiency = std(efficiency);
if i == 1
    half_std = std_efficiency/2;
end
Cost = 4 * 1/std_params + 1/(T_l_max-T_l_min) + 1/(V_max-V_min);
RESULT(i,1) = std_params;
RESULT(i,2) = Cost;
RESULT(i,3) = std_efficiency;
i = i+1;
std_params = std_params - 0.01;
end

% • RESULT is n x 3 matrix
% • with coloumns --> std dev of params | Cost | std dev of efficiency
% • RESULT(:,3) < half_std --> will return all indices where std dev of max 
%   efficiency has been reduced by 50%

chk = RESULT(:,3) < half_std;
idx_min = find(RESULT(:,2) == min(RESULT(chk,2)));
RESULT(idx_min,:) % desired row with std(max_efficiency) < 50pc AND min Cost
