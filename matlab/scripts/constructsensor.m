function [gsRec, gsReal] = constructsensor(event, index, src)

% sensor que se quiere reconstruir dado en indice dado
gs = event.gss(index);
gsReal = gs.data;

% taman~o de remuestreo de sincronizacion
L = 20000;

% tiempo común entre el sensor y la fuente
time = linspace(min(src(1,1), gs.timevector(1)), gs.timevector(end), L);

% fuente en tiempo comun
src2 = interp1(src(:,1), src, time);
src2(isnan(src2)) = 0;
src2 = src2(:,2:4)';

% con el sensor podemos convolucionar con respecto el kernel de green
R = event.gss(1).r0 - event.LocR;
timeDomain = time - event.origin_time;

% parametros fisicos
alpha = event.alpha;
beta = event.beta;
rho = event.rho;
[G11,G12,G13,G22,G23,G33] = scalarGreenKernel(R(1), R(2), R(3), timeDomain, alpha, beta, rho);

% simetrias del kernel de Green
G21 = G12;
G31 = G13;
G32 = G23;

% diferencial de tiempo para la convolución
dt = time(2) - time(1);

% reconstrucción mediante teorema de convolución
% recontrucción mediante convolucion
sourceX = (conv(G11,src2(1,:)) + conv(G12,src2(2,:)) + conv(G13,src2(3,:)) )*dt;
sourceY = (conv(G21,src2(1,:)) + conv(G22,src2(2,:)) + conv(G23,src2(3,:)) )*dt;
sourceZ = (conv(G31,src2(1,:)) + conv(G32,src2(2,:)) + conv(G33,src2(3,:)) )*dt;

% ventana de tiempo de la convolucion
convtime = linspace(timeDomain(1) + time(1), timeDomain(end) + time(end), 2*L-1);

% convolucion en la ventana de la fuente
gsRec = interp1( convtime', [sourceX; sourceY; sourceZ]', gs.timevector');
end
