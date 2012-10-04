function obj = test(obj,i,j,k)
%TEST Summary of this function goes here
%   Detailed explanation goes here

%tomamos "length" modelos de un sensor con los cuales deduciremos el
%verdadero centro
x0 = obj.LocX;
y0 = obj.LocY;
z0 = obj.LocZ;

%reemplazar las mediciones de los sensores como si fuera un pulso (1,0,0)
for iter= 1:obj.length 
    xk = obj.position(iter).x0;
    yk = obj.position(iter).y0;
    zk = obj.position(iter).z0;
    T  = obj.position(iter).T;
    t0 = obj.origin_time;
    [G11,G12,G13,G22,G23,G33] = obj.escalar_green_kernel(xk-x0,yk-y0,zk-z0,T-t0,obj.alpha,obj.beta,obj.rho);
    obj.position(iter).X = G11*i+G12*j+G13*k;
    obj.position(iter).Y = G12*i+G22*j+G23*k;
    obj.position(iter).Z = G13*i+G23*j+G33*k;
end

end

