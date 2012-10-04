function [ X Y Z X_domain Y_domain Z_domain T_domain,mu] = test_with_real_locations(obj)
%TEST_WITH_IDEAL_LOCATIONS Summary of this function goes here
%   Detailed explanation goes here
alpha = obj.alpha; 
beta  = obj.beta; 
rho = obj.rho; 

% posición y tiempo estimados
LocR = obj.LocR;
origin_time = obj.origin_time;
error = 0.00;
tail_per = 0.0;
% crear un modelo con estos parámetros
mu = model(alpha,beta,rho,LocR,origin_time, error, tail_per);
r0 = obj.r0;
n = 30;
for i = 1:obj.count
    r = r0(i,:);    
    origin_time = obj.origin_time;
    trigger_position = 0;
    %t time no se ve corregido aun %
    t_time = obj.gss(i).t_time - obj.gss(i).TriggerPosition/obj.gss(i).hardware_sampling_rate; 
%     p_time = obj.gss(i).p_time; 
%     s_time = obj.gss(i).s_time;
    
    p_time = norm(LocR-r)/alpha + origin_time; 
    s_time = norm(LocR-r)/beta + origin_time ;
    
    sampling_rate  = n/(2*s_time - p_time - t_time);
    
    gs  = geosensor(r, t_time, sampling_rate, trigger_position, p_time, s_time,1,1,1,0);
    
    data = model.TestData(LocR, origin_time, r, t_time, p_time, s_time, alpha, beta, rho, n);
    mu.addGeosensor(gs,data); % cargar geosensor
end
mu = mu.conv_parameters(25);
[X Y Z X_domain Y_domain Z_domain T_domain] = mu.reverse_signal();
disp('Time reversal is Done!');
end


