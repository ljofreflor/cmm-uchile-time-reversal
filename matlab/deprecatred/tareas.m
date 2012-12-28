% tareas

% 1. Dado s fuente (t0, r0, s(\tau)) dado r_k posición geófono k
% Events = importEvents();
% 5 hacer andar el test

event = Ev(1);
% evento artificial y fuente artificial
[art, artsrc] = eventoArtificial(event);

[recartsrc, ~, error] = source(art,length(artsrc), artsrc(end,1) - artsrc(1,1), 0);
plot(recartsrc(:,1), recartsrc(:,2:4))
% graficos de comparación entre fuente estimada

plot(artsrc(:,1),artsrc(:,2:4))
hold
plot(recartsrc(:,1),recartsrc(:,2:4))
hold

[src, ~, error] = source2(art,length(artsrc), artsrc(end,1) - artsrc(1,1), 0);







