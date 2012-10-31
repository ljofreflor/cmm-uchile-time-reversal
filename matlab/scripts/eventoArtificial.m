function [art, src] = eventoArtificial( event )
%EVENTOARTIFICIAL dado un evento, genera un evento artificial para hacer
%pruebas de funcionamiento de los algoritmos.

% copiar el evento a un evento artificial
art = event;
t0 = art.origin_time;
r0 = art.LocR;
alpha = art.alpha;
beta = art.beta;
rho = art.rho;

% cambiar la fuente de este evento por una fuente imposible
for ii = 1:art.count
    art.gss(ii).data = datosArticiales(art.gss(ii), t0, r0, alpha, beta, rho);
    art.gss(ii).IsAccelerometer = 0;
    art.gss(ii).IsSpeedometer = 0;    
end

[~, src] = datosArticiales(art.gss(ii), t0, r0, alpha, beta, rho);
end

