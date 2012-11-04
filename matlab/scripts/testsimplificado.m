% test con evento simplificado

data = [ 0 0 0; 1 0 0; 0 1 0; 0 0 1; 0 0 0];
sourcetime = [ 0 1 2 3 4 ]';
alpha = 100;
beta = 10; 
rho = 1;
% tiempo del sensor.
sensortime = 10:100;
% posicion del sensor
r = [0 0 1000];

% sincronizar el tiempo entre el sensor y la fuente
sinctime = linspace(min(sourcetime), max(sensortime),100);
% tiempo sincronizado entre el sensor y la fuente
[G11,G12,G13,G22,G23,G33] = scalarGreenKernel(r(1),r(2),r(3), sinctime, alpha, beta, rho);

%construcción sensor(es)
srcdatasinc = interp1(sourcetime', data, sinctime');
srcdatasinc(isnan(srcdatasinc)) = 0;
% convolucion
G21 = G12;
G31 = G13;
G32 = G23;
dt = sinctime(2) - sinctime(1);
datax = convolution3d(G11',G12',G13',srcdatasinc(1), srcdatasinc(2), srcdatasinc(3), dt);
datay = convolution3d(G21',G22',G23',srcdatasinc(1), srcdatasinc(2), srcdatasinc(3), dt);
dataz = convolution3d(G31',G32',G33',srcdatasinc(1), srcdatasinc(2), srcdatasinc(3), dt);

datasensor = [datax, datay, dataz];

% interpolar a el tiempo del sensor

gs = Geosensor(r,0,1,0,100,10,1,1,1,0);
events = Event('prueba',100,10,1,[0 0 0],0,0,0);
event = events.addGeosensor(gs, datasensor);

% reconstruir la fuente

[src, ~ , ~, ~] = source(event,5,1,1);


