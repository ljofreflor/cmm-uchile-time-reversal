function [it, ft] = AllEventWindows(event)
% todos los tiempos iniciales y todos los tiempos finales
firsttimes = [event.gss.p_time]';
lasttimes = [event.gss.s_time]';
cuttimes = [event.gss.cuttime]';
r0 = vertcat(event.gss.r0);

for ii = 1:size(r0,1)
dist(ii,:) = (r0(ii,:) - event.LocR).^2;
end

norm2dist = sqrt(sum(dist,2));

its1 = firsttimes - norm2dist/event.alpha;
its2 = lasttimes - norm2dist/event.beta;
fts = cuttimes - norm2dist/event.beta;

% buscamos la interseccion de todos los intervalos que contienen a
% event.origin_time.
it = min([its1; its2]);
ft = mean(fts);
end