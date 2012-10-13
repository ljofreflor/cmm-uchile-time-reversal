function [gsRec, gsReal, error] = recon(event, gss, src)
% dado que se tiene una fuente estimada es posible obtener
srctime = src(:,1);
sensortime = gss.timevector;

% taman~o de remuestreo
L = 100000;

% tiempo común entre el sensor y la fuente
time = linspace(min(srctime(1), sensortime(1)), sensortime(end), L);

% fuente en tiempo comun
src2 = interp1(srctime, src, time);
src2(isnan(src2)) = 0;
src2 = src2(:,2:4)';

% con el sensor podemos convolucionar con respecto el kernel de green
R = event.gss(1).r0 - event.LocR;

timeDomain = time - event.origin_time;
[G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(R(1),R(2),R(3),timeDomain, event.alpha, event.beta, event.rho);

% simetrias
G21 = G12;
G31 = G13;
G32 = G23;

recsrc = zeros(size(src2));

% convolucion de la fuente con respecto el kernel de Green
recsrc(1,:) = ifft(fft(G11).*fft(src2(1,:)) + fft(G12).*fft(src2(2,:)) + fft(G13).*fft(src2(3,:)));
recsrc(2,:) = ifft(fft(G21).*fft(src2(1,:)) + fft(G22).*fft(src2(2,:)) + fft(G23).*fft(src2(3,:)));
recsrc(3,:) = ifft(fft(G31).*fft(src2(1,:)) + fft(G32).*fft(src2(2,:)) + fft(G33).*fft(src2(3,:)));

% reconstrucion en la ventana de la fuente
gs.hat = interp1( time', recsrc', sensortime');
gs.hat(isnan(gs.hat)) = 0;
gs.real = detrend(cumsum(gss.data));
error = norm(gs.hat(:,1) - gs.real(:,1), 1)/norm(gs.real(:,1), 1) + ...
    norm(gs.hat(:,2) - gs.real(:,2), 1)/norm(gs.real(:,2), 1) + ...
    norm(gs.hat(:,3) - gs.real(:,3), 1)/norm(gs.real(:,3), 1);

gsRec = gs.hat;
gsReal = gs.real;

end
