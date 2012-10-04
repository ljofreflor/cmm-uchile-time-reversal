function [ X Y Z ] = test_asimetrico()
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
mu = Event(alpha,beta,rho,LocR,origin_time, error, tail_per);
r0 = [-1 -1 0; -1,0,0; -1,1,0];
n = 30;
for i = 1:length(r0(:,1))
    r = r0(i,:);    
    origin_time = 0;
    trigger_position = 0;
    t_time = origin_time; 
    p_time = norm(LocR-r)/alpha + origin_time; 
    s_time = norm(LocR-r)/beta + origin_time;
    
    sampling_rate  = n/(2*s_time - p_time - origin_time);
    
    gs  = Geosensor(r, t_time, sampling_rate, trigger_position, p_time, s_time,1,1,1,0);
    data = Event.TestData(LocR, origin_time, r, t_time, p_time, s_time, alpha, beta, rho,n);
    mu = mu.addGeosensor(gs,data); % cargar geosensor
end
mu = mu.conv_parameters(25);
[X Y Z] = mu.reverse_signal();
disp('Time reversal is Done!');
end







