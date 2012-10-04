
% todos los nombres est'an en orden alfab'etico?
% todos los tiempos de llegada de la onda p son menores a los tiempos de
% llegada de la onda s

gsslist   = [mu.gss];
ptimelist = [gsslist.p_time];
stimelist = [gsslist.s_time];

% verificar que de todos los sensores cuantos son acelerometros y
% velocimetros.