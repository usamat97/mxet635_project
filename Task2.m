clear;
close all;
V = 12;
K = 0.397; 
L = 0.2*10^-4;
J = 1.3*10^-5;
R = 1.77;
T_f = 0.115;
T_l = 2.58;
period = 1700;
duty_cycle = 99;

output = sim('task2_motor_current_speed', [0:0.000001:0.003]);
t = output.tout;
current = output.yout{1}.Values.Data;
speed = output.yout{2}.Values.Data;
voltage = output.yout{3}.Values.Data;
torque = output.yout{4}.Values.Data;
figure(1)
plot(t,voltage);
hold on
plot(t,torque);
figure(2)
yyaxis left;
plot(t,current);
yyaxis right;
plot(t,speed);

SI_input = [voltage torque];
SI_output = [current speed];
dataMotor = iddata(SI_output , SI_input, 0.000001);