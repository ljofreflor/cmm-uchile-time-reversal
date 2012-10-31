function [gsRec, gsReal] = recon(event, index, src)

% sensor que se quiere reconstruir dado en indice dado
gss = event.gss(index);

% taman~o de remuestreo
L = 100000;

% tiempo común entre el sensor y la fuente
time = linspace(min(src(1,1), gss.timevector(1)), gss.timevector(end), L);

% fuente en tiempo comun
src2 = interp1(src(:,1), src, time);
src2(isnan(src2)) = 0;
src2 = src2(:,2:4)';

% con el sensor podemos convolucionar con respecto el kernel de green
R = event.gss(1).r0 - event.LocR;

% ventana de tiempo
timeDomain = time - event.origin_time;
[G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(R(1),R(2),R(3),timeDomain, event.alpha, event.beta, event.rho);

% simetrias
G21 = G12;
G31 = G13;
G32 = G23;

% donde almacenar el sensor reconstruido
recsns = zeros(size(src2));

% diferencial de tiempo
dt = time(2)-time(1);

% reconstrucción mediante teorema de convolución
% recontrucción mediante convolucion
sourceX = (ifft(fft(G11).*fft(src2(1,:))) + ifft(fft(G12).*fft(src2(2,:))) + ifft(fft(G13).*fft(src2(3,:))))*dt;
sourceY = (ifft(fft(G21).*fft(src2(1,:))) + ifft(fft(G22).*fft(src2(2,:))) + ifft(fft(G23).*fft(src2(3,:))))*dt;
sourceZ = (ifft(fft(G31).*fft(src2(1,:))) + ifft(fft(G32).*fft(src2(2,:))) + ifft(fft(G33).*fft(src2(3,:))))*dt;

% recontrucción mediante convolucion.

% sourceX = (conv2(G11 , src2(1,:)) + conv2(G12 , src2(2,:)) +conv2(G13 , src2(3,:)))*dt;
% sourceY = (conv2(G21 , src2(1,:)) + conv2(G22 , src2(2,:)) +conv2(G23 , src2(3,:)))*dt;
% sourceZ = (conv2(G31 , src2(1,:)) + conv2(G32 , src2(2,:)) +conv2(G33 , src2(3,:)))*dt;


% la reconstruccion de la fuente es en otra ventana de tiempo dado el tipo
% de convolución
timeConv = linspace(time(1),time(end), length(sourceX));

% reconstrucci'on con la ventana de la fuente
gsRec = interp1( timeConv', [sourceX; sourceY; sourceZ]', gss.timevector');
gsReal = detrend(cumsum(gss.data));

end
