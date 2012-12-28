%qué tan robusto es el modelo en funci'on de cambios de ciertos parametros

Events = importEvents();             % Importa todos los archivos a una lista de objetos events
n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n);                   % Evento en estudio, puede ser en 1:event.count
% forma de la fuente y error de estimación

% distintas fuentes, con distintas precisiones
for i = 1:5
    nSrc = 256/(2^(i-1));
    dt = .0005*(2^(i-1));
    [src{i}, cutsrc{i}, filtsrc{i}, filtcutsrc{i}, error] = source(event, nSrc, dt);    
end


