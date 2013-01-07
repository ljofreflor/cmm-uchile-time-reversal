%% ejemplo de inversion en el tiempo de los campos de desplazamiento de los
% La función import events transforma los archivos generados con script en
% python a una lista de objetos del tipo Event.

%% Importar los archivos desde python por medio de la consola matlab
% 

%unix('python ../python/src/readFile.py'); % descomentar si tiene eventos
%nuevos en la carpeta "data sets"

%% importamos los eventos
ev = importEvents();

%%
% con los archivos ya importados en la variable ev = $ev_1,\cdot, ev_n$
% donde $n$ es la cantidad de geosensores.
% tomamos un evento sísmico de los n existentes, podemos considerar por
% ejemplo, el evento $3$
index = 3;
% se invierte el campo de desplazamiento remuestreado.
[X, Y, Z, X_dom, Y_dom, Z_dom, T_dom] = reverse_signal(ev(index));

%% dominio de la inversión
% el dominio definido por X_domain, Y_domain, Z_domain, T_domain son de
% $60 \times 60 \times 10 \times 50$ cuya presición de la discretización
% está dada por $dx =  14.7890$, $dy =  13.9790$, $dz = 34.7967$
% metros y dependen de la cobertura de los geófonos, este cubo es en
% realidad el cubo de volumen mínimo que contiene a todos los geófonos.

%% visualizacion de la inversion de los datos
% con las mediciones ya obtenidas de la unversión de las señales se
% considera la visualización de la norma del campo vectorial para
% visualización.

N = sqrt(X.^2 + Y.^2 + Z.^2);

for i = 1:length(ev(index).t_axis)
    %% gráfico
     imagesc(N(:,:,floor(end/2),i));  
end







