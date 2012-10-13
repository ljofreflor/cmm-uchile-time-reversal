function [ X Y Z ] = standat_test_adjusted()
%TEST_WITH_IDEAL_LOCATIONS Summary of this function goes here
%   Detailed explanation goes here
alpha = 5600; 
beta  = 3500; 
rho = 2700; 

% posición y tiempo estimados
LocR = [0 0 0];
origin_time = 0;
error = 0.00;
tail_per = 0.0;
% crear un modelo con estos parámetros
mu = model(alpha,beta,rho,LocR,origin_time, error, tail_per);
r0 = [-1 -1 0; 0 -1 0; 1 -1 0; 1 0 0; 1 1 0; 0 1 0; -1 1 0;-1 0 0];
n = 30;
for i = 1:8
    r = r0(i,:);    
    
    trigger_position = 0;
    t_time = origin_time; 
    p_time = origin_time + norm(LocR-r)/alpha; 
    s_time = origin_time + norm(LocR-r)/beta;
    
    sampling_rate  = n/(2*s_time - p_time - origin_time);
    
    P_valid = 1;
    S_valid = 1;
    SP_valid = 1;
    gs  = geosensor(r, t_time, sampling_rate,...
        trigger_position, p_time, s_time,P_valid,S_valid,SP_valid,0);
    
    data = (norm(r - LocR,2)/)*model.TestData(LocR, origin_time, r, t_time, p_time, s_time, alpha, beta, rho,n);
    mu.addGeosensor(gs,data); % cargar geosensor com
    
end
mu = mu.conv_parameters(25);
[X Y Z] = mu.reverse_signal();
disp('Time reversal is Done!');
end

