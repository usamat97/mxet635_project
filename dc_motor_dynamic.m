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

output = sim('motor_current_speed', [0:0.0001:1]);
t = output.tout;
current = output.yout{1}.Values.Data;
speed = output.yout{2}.Values.Data;
figure(1)
plot(t,speed);


