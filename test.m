
T_l_min = 0.05;
T_l_max = 0.2;
T_l_range = T_l_min:0.01:T_l_max;
N = size(T_l_range);

(T_l_max - T_l_min) * 0.1
(T_l_max - T_l_min) * 0.09
(T_l_max - T_l_min) * 0.08
(T_l_max - T_l_min) * 0.07

T_l_max = T_l_max *(1-0.09)
T_l_min = T_l_min *(1+0.09)
T_l_max
T_l_min