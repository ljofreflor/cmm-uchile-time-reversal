function [ X Y Z ] = standar_test_2()
%TEST_WITH_IDEAL_LOCATIONS Summary of this function goes here
%   Detailed explanation goes here
alpha = 5600; 
beta  = 1000; 
rho = 2700; 

% posición y tiempo estimados
LocR = [0 0 0];
origin_time = 0;
error = 0.00;
tail_per = 0.0;
% crear un modelo con estos parámetros
mu = model(alpha,beta,rho,LocR,origin_time, error, tail_per);
r0 = [-1 -1 1; 0 -1 1; 1 -1 1; 1 0 1; 1 1 1; 0 1 1; -1 1 1;-1 0 1; ...
    -1 -1 -1; 0 -1 -1; 1 -1 -1; 1 0 -1; 1 1 -1; 0 1 -1; -1 1 -1;-1 0 -1];
for i = 1:16
    r = r0(i,:);    
    sampling_rate  = 0;
    trigger_position = 0;
    tv_usec = norm(LocR-r)/alpha; 
    p_time = norm(LocR-r)/alpha; 
    s_time = norm(LocR-r)/beta;
    gs  = geosensor(r, tv_usec, sampling_rate, trigger_position, p_time, s_time,1,1,1);
    mu = mu.add_test_geosensor(gs); % cargar geosensor
end
mu = mu.conv_parameters(25);
[X Y Z] = mu.reverse_signal();
disp('Time reversal is Done!');
end





