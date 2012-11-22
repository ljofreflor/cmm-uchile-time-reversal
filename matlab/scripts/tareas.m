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

% % algunos resultados
% % norm(recartsrc, 1)
% %
% % ans =
% %
% %    9.9899e+14
% 
% for ii = 1:event.count    
%     % dada estas fuentes reestimar los geofonos.
%     [gsRec{ii}, gsReal{ii}] = constructsensor(art, ii, recartsrc);
% end
% 
% % 2. Dado u_1,\cdots, u_k geófonos estimar la fuente u hacer el cálculo de
% % la norma 2 de la distancia entre el sensor estimado y el real.
% 
% % 4 calcular las distancias entre el sensor estimado y el real
% for ii = 1:art.count
%     dist{ii} = norm(gsRec{ii} - gsReal{ii},2);
%     norrec{ii}  = norm(gsRec{ii},2);
%     nor{ii} = norm(gsReal{ii},2);
% end
% 
% % eventos reales






