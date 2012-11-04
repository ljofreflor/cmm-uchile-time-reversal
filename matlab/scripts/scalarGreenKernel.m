function [G11,G12,G13,G22,G23,G33] = scalarGreenKernel(x,y,z,T, alpha, beta, rho)
%ESCALAR_GREEN_KERNEL Summary of this function goes here
% Detailed explanation goes here

%% distancia euclideana
r = sqrt((x)^2+(y)^2+(z)^2);
e = T(2)-T(1);
c_1 = (r/alpha < T & T < r/beta);
% test: no existen diferencias entre los coeficientes provenientes de los
% vertices del dominio ni los que están a mediados de las aristas
% plot(c_1);
c_2 = T > r/alpha;
c_2 = fliplr(c_2);
c_2 = diff(c_2);  
c_2(end + 1) = 0;
c_2 = fliplr(c_2);
c_2 = abs(c_2);

% test: no existen diferencias entre los coeficientes provenientes de los
% vertices del dominio ni los que están a mediados de las aristas
% plot(c_2);
c_3 = T > r/beta;
c_3 = fliplr(c_3);
c_3 = diff(c_3);  
c_3(end + 1) = 0;
c_3 = fliplr(c_3);
c_3 = abs(c_3);

% test: no existen diferencias entre los coeficientes provenientes de los
% vertices del dominio ni los que están a mediados de las aristas
% plot(c_3);
c_1 = and(c_1,not(c_2));
c_1 = and(c_1,not(c_3));

c_1 = (T).*c_1./(4*pi*rho*(r^3));

c_2 = c_2/e;
c_3 = c_3/e;


c_2 = c_2./(4*pi*rho*alpha^2*r^3);
c_3 = c_3./(4 * pi * rho * beta^2 * r);
% The equations for the Green's function is
G11 = (3*(x*x) / (r^2)-1).*c_1 + (x^2).*c_2 - ((x*x)/(r^2)-1).*c_3;
G12 = (3*(x*y) / (r^2)  ).*c_1 + (x*y).*c_2 - ((x*y)/(r^2)  ).*c_3;
G13 = (3*(x*z) / (r^2)  ).*c_1 + (x*z).*c_2 - ((x*z)/(r^2)  ).*c_3;
G22 = (3*(y*y) / (r^2)-1).*c_1 + (y^2).*c_2 - ((y*y)/(r^2)-1).*c_3;
G23 = (3*(y*z) / (r^2)  ).*c_1 + (y*z).*c_2 - ((y*z)/(r^2)  ).*c_3;
G33 = (3*(z*z) / (r^2)-1).*c_1 + (z^2).*c_2 - ((z*z)/(r^2)-1).*c_3;

end

