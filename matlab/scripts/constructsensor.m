function [gsRec] = constructsensor(event, index, src)

% sensor que se quiere reconstruir dado en indice dado
gs = event.gss(index);

% taman~o de remuestreo de sincronizacion
L = 20000;

% tiempo com煤n entre el sensor y la fuente
time = linspace(min(src(1,1), gs.timevector(1)), gs.timevector(end), L);

% fuente en tiempo comun
srcSinc = interp1(src(:,1), src(:,2:4), time);
srcSinc(isnan(srcSinc)) = 0;

% con el sensor podemos convolucionar con respecto el kernel de green
R  = event.gss(index).r0 - event.LocR;
timeDomain = time - event.origin_time;

[G11,G12,G13,G22,G23,G33] = scalarGreenKernel(R(1), R(2), R(3), timeDomain, event.alpha, event.beta, event.rho);

% simetrias de la funcion de Green
G21 = G12;
G31 = G13;
G32 = G23;

% diferencial de tiempo para la convoluci贸n
dt = time(2) - time(1);
% recontrucci贸n mediante convolucion
sourceX = ( conv(G11, srcSinc(:,1)) + conv(G12, srcSinc(:,2)) + conv(G13, srcSinc(:,3)) )*dt;
sourceY = ( conv(G21, srcSinc(:,1)) + conv(G22, srcSinc(:,2)) + conv(G23, srcSinc(:,3)) )*dt;
sourceZ = ( conv(G31, srcSinc(:,1)) + conv(G32, srcSinc(:,2)) + conv(G33, srcSinc(:,3)) )*dt;

% ventana de tiempo de la convolucion
convtime = linspace(timeDomain(1) + time(1), timeDomain(end) + time(end), 2*L - 1);

% convolucion en la ventana de la fuente
gsRec = interp1(convtime', [sourceX, sourceY, sourceZ], gs.timevector');

end
