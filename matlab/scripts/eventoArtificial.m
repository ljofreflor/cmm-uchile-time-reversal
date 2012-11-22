function [art, src] = eventoArtificial( event )
%EVENTOARTIFICIAL dado un evento, genera un evento artificial para hacer
%pruebas de funcionamiento de los algoritmos.

% copiar el evento a un evento artificial
art = event;

% la fuente artificial con la cual se crearan los sensores, se espera que
% los sensores capturen a toda la fuente por lo que es necesario que el
% tiempo y la frecuencia de la fuente sean en funcion del tiempo inicial de
% los sensores
sinctime = linspace(art.origin_time, art.origin_time + 0.01, 70)';

% fuente escalonada
src = zeros([length(sinctime) 3]);
src(10:25,1) = 10^(14);
src(30:45,2) = 10^(14);
src(50:65,3) = 10^(14);

% concatenar con el vector de tiempo
src = [sinctime src];

% generar todos los sensores artificiales dado la fuente artificial
for index = 1:art.count
    % sobreescribir las mediciones reales con las del sensor con la fuente
    % imposible.
    art.gss(index).data = constructsensor(event, index, src);
    
    % los nuevos sensores artificiales contienen campo de desplazamiento
    % por lo que los flag de ecelerometro y velocimentro quedan en cero.
    art.gss(index).IsAccelerometer = 0;
    art.gss(index).IsSpeedometer = 0;    
end
end

