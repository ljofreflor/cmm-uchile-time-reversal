function data = testDatafunction(ev,index,time)

i = 0;
j = 0;
k = 1;

sensor = ev.gss(index);
r = sensor.r0 - ev.LocR;
alpha = ev.alpha;
beta = ev.beta;
rho = ev.rho;

n = length(time);
[G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(r(1),r(2),r(3),time,alpha,beta,rho);
% se considera la fuente un impulso unitario en direccion del eje z
data = zeros(n,3);
data(:,1) = G11*i+G12*j+G13*k;
data(:,2) = G12*i+G22*j+G23*k;
data(:,3) = G13*i+G23*j+G33*k;

end