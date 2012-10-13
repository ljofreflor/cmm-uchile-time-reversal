clear;
import_all;
mu(1).conv_parameters(10);

for ii = 1:mu(1).count
    
    alpha = mu(1).alpha;
    beta = mu(1).beta;
    tp = mu(1).gss(ii).p_time;
    ts = mu(1).gss(ii).s_time;
    dist = mu(1).dis_to_src(ii);
    t0 = mu(1).origin_time;
    
    m1 = dist*(1/alpha - 1/beta)/(tp - ts);
    
    m2 = dist*((ts-t0)/alpha - (tp-t0)/beta)/(ts - tp);
    
    mu(1).gss(ii).T = (mu(1).gss(ii).T - t0)*m1 + m2 + t0;
    
    mu(1).gss(ii).r_x = mu(1).gss(ii).r_x*(mu(1).gss(ii).dis_to_src)^2;
    mu(1).gss(ii).r_y = mu(1).gss(ii).r_y*(mu(1).gss(ii).dis_to_src)^2;
    mu(1).gss(ii).r_z = mu(1).gss(ii).r_z*(mu(1).gss(ii).dis_to_src)^2;
end

r0 = mu(1).LocR;
delta = min(mu(1).dis_to_src);
x1 = r0(1)+delta;
x2 = r0(1)-delta;
y1 = r0(2)+delta;
y2 = r0(2)-delta;
z1 = r0(3)+delta;
z2 = r0(3)-delta;
t1 = 0;
t2 = 1.5*(mu(1).last_time-mu(1).first_time);

%mu(1).setNewDomain(x1,x2,40,y1,y2,40,z1,z2,10,t1,t2,40);
[X Y Z] = mu(1).reverse_signal;