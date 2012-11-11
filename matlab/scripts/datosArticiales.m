function [data, src] = datosArticiales(event, index)
%datos artificiales creados generados por una fuente con forma de impulsos
%cuadrados.

t0 = event.origin_time;
% tiempo sincronizado para convolucionar
sinctime = linspace(t0, t0 + 0.05, 200);

% fuente escalonada
src = zeros([length(sinctime) 3]);

src(10:50,2)   = 10^10;
src(60:100,1)  = 10^10;
src(110:150,3) = 10^10;

src = [sinctime' src];
% reconstruccion de la fuente dado el sensor
%data = recon(event,index, src);
data = constructsensor(event, index, src);

end