% tareas

% 1. Dado s fuente (t0, r0, s(\tau)) dado r_k posición geófono k
Events = importEvents();
% 5 hacer andar el test

event = Events(1);
% evento artificial y fuente artificial
[art, artsrc] = eventoArtificial(event);
nSrc = 250;
dt = 0.0005;
[recartsrc, ~, ~, ~] = source(art, nSrc, dt, 1:art.count);

% graficos de comparación entre fuente estimada

hold
plot(recartsrc(:,1),recartsrc(:,2:4))
hold
%

% reconstucci'on de la fuente con el nuevo algoritmo
[recsrc, ~, ~, ~] = source(event, nSrc, dt, [1:2 4:event.count]);

for ii = 1:event.count
    % obtener las fuentes estimadas con cada sensor de forma independiente
    [src{ii}, filtsrc{ii}, ~, ~] = source(art,nSrc,dt,ii);
    
    % dada estas fuentes reestimar los geofonos.
    [gsRec{ii}, gsReal{ii}] = recon(art, ii, src{ii});
end

% 2. Dado u_1,\cdots, u_k geófonos estimar la fuente u hacer el cálculo de
% la norma 2 de la distancia entre el sensor estimado y el real.

[srcAll, ~, ~, ~, ~] = source(event, nSrc, dt, 1:event.count);

% 3 recalcular los sensores
for ii = 1:event.count
    [gsRec{ii}, gsReal{ii}] = recon(art, ii, recartsrc);
end

% 4 calcular las distancias entre el sensor estimado y el real
for ii = 1:event.count
    dist{ii} = norm(gsRec{ii} - gsReal{ii},2);
    norrec{ii}  = norm(gsRec{ii},2);
    nor{ii} = norm(gsReal{ii},2);
end






