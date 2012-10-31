% tareas

% 1. Dado s fuente (t0, r0, s(\tau)) dado r_k posición geófono k
Events = importEvents();
event = Events(1);
nSrc = 250;
dt = 1/4800;
% eliminar el sensor con sensor_id = 25
event.gss = event.gss([1:2 4:event.count]);
event.count = event.count - 1;
for ii = 1:event.count
    % obtener las fuentes estimadas con cada sensor de forma independiente
    [src{ii},~, filtsrc{ii}, ~, ~, ~] = source(event,nSrc,dt,ii);
    
    % dada estas fuentes reestimar los geofonos.
    [gsRec{ii}, gsReal{ii}] = recon(event, ii, src{ii});
end

% 2. Dado u_1,\cdots, u_k geófonos estimar la fuente u hacer el cálculo de
% la norma 2 de la distancia entre el sensor estimado y el real.

[srcAll, ~, ~, ~, ~] = source(event, nSrc, dt, 1:event.count);

% 3 recalcular los sensores
for i = 1:event.count
    [gsRecAll{ii}, gsRealAll{ii}] = recon(event, ii, srcAll{ii});
end

% 4 calcular las distancias entre el sensor estimado y el real
for ii = 1:event.count
    dist{ii} = norm(gsRecAll{ii} - gsRealAll{ii},2);
    nor{ii} = norm(gsRealAll{ii},2);
end
% 5 hacer andar el test

event = Events(1);
% evento artificial y fuente artificial
[art, artsrc] = eventoArtificial(event);
nSrc = 250;
dt = 1/4800;
[srctest, ~, ~, ~, ~] = source(art, nSrc, dt, 1:art.count);





