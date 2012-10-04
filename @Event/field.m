function [SUM_X, SUM_Y, SUM_Z] = field(obj,id)
%FIELD campo de la señal en el k ésimo instante, el valor de obj.tdim(k)
% dependerá de como esté definido el dominio

r_x = obj.gss(id).r_x;
r_y = obj.gss(id).r_y;
r_z = obj.gss(id).r_z;
t   = obj.gss(id).timeresamplevector;

%dominio espacio temporal
X = obj.X_domain; 
Y = obj.Y_domain; 
Z = obj.Z_domain; 
T = obj.T_domain;

% kernel del gre,en para un instante s
SUM_X = zeros(size(obj.X_domain));
SUM_Y = SUM_X;
SUM_Z = SUM_X;

x0 = obj.gss(id).r0(1);
y0 = obj.gss(id).r0(2);
z0 = obj.gss(id).r0(3);

alpha = obj.alpha; 
beta = obj.beta; 
rho = obj.rho;

for ii = (obj.gss(id).resampleSize - 1):-1:1
    ii
    %s  = obj.tau-t(ii); 
    s  = t(ii); 
    ds = obj.gss(id).period(ii);
    [G11,G12,G13,G22,G23,G33] = ...
        obj.vectorialGreenKernel(X - x0, Y - y0, Z - z0, T + s - obj.last_time, ds, alpha, beta, rho);
    G11 = G11.*( (t(ii) + T - obj.last_time) >= 0 );
    G12 = G12.*( (t(ii) + T - obj.last_time) >= 0 );
    G13 = G13.*( (t(ii) + T - obj.last_time) >= 0 );
    G22 = G22.*( (t(ii) + T - obj.last_time) >= 0 );
    G23 = G23.*( (t(ii) + T - obj.last_time) >= 0 );
    G33 = G33.*( (t(ii) + T - obj.last_time) >= 0 );


    SUM_X = SUM_X + (G11 * r_x(ii) + G12 * r_y(ii) + G13 * r_z(ii))*ds;
    SUM_Y = SUM_Y + (G12 * r_x(ii) + G22 * r_y(ii) + G23 * r_z(ii))*ds;
    SUM_Z = SUM_Z + (G13 * r_x(ii) + G23 * r_y(ii) + G33 * r_z(ii))*ds;
end
end

