function [art, src] = eventoArtificial( event )
%EVENTOARTIFICIAL dado un evento, genera un evento artificial para hacer
%pruebas de funcionamiento de los algoritmos.

% copiar el evento a un evento artificial
art = event;

% la fuente artificial con la cual se crearan los sensores
sinctime = linspace(art.origin_time - 0.025, art.origin_time + 0.025, 200)';

% fuente escalonada
src = zeros([length(sinctime) 3]);
src(10:50,2)   = 1;
src(60:100,1)  = 1;
src(110:150,3) = 1;

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

