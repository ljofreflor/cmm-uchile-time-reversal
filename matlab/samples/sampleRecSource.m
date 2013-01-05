%% Importar los archivos desde python por medio de la consola matlab
% 

%unix('python ../python/src/readFile.py'); % descomentar si tiene eventos
%nuevos en la carpeta "data sets"

%% importar los eventos
% importar todos los eventos que están en la carpeta "data sets"
ev = importevents();

%% evento de ejemplo
% El evento que se empleará será el tercero de la lista por que describe
exev = ev(3);

%% construccion de la fuente
% mediante la función source se recosntruye la fuente sismica

[exev.src, exev.filtsrc, exev.error] = source(exev, 100, 0.5,0.09);
%% visualización de la fuente sismica con la totalidad de geofonos
plotSrc(exev);
%% visualización de la fuente filtrada con la totalidad de geofonos
plotFiltSrc(exev);



%% selección de los geófonos
% no se aprecia una fuente muy clara, la razón de esto es que existen
% geófonos cuyas mediciones no son correctas, por ejemplo, se ha logrado ha
% identificado que el sensor con el atributo sensor_id = $25$ genera
% mediciones incorrectas, por lo tanto, para todos los eventos se ha de
% eliminar ese geosensor.
i = find([exev.gss.sensor_id] == 25);
exev.gss(i) = []; % con esto eliminamos el sensor con el atributo sensor_id = $25$

%% visualización de la fuente sismica
plotSrc(exev);
%% visualización de la fuente filtrada
plotFiltSrc(exev);
%% visualizacion de la fuente filtrada y rotada
plotFiltRotSrc(exev);

%% rotación y clasificación de los sismos
% Ya conociendo la forma de encontrar la forma de la fuente en un punto, se
% busca encontrar todas la cantidad se señal en cada eje de la señal rotada
% de tal manera
for iter = 1:length(ev)
    [ev(iter).src, ev(iter).filtsrc, ev(iter).error] = source(ev(iter), 100, 0.5,0.09);
    [ev(iter).vr1, ev(iter).vr2, ev(iter).vr3] = eventCoeficients(rotate(ev(iter).filtsrc));
end



%% clasificación de eventos 
% clasificar los eventos nos permite deducir propiedades del lugar en donde
% ocurre el evento. Se buscará una clasificación natural de los sismos

vr1 = [ev.vr1]';
vr2 = [ev.vr2]';
vr3 = [ev.vr3]';

X = vr1;

data = [X zeros(size(X))];
IDX = kmeans(data,3);

% GRAFICO
plot(data(IDX ==1,1),data(IDX ==1,2),'r.')
hold on
plot(data(IDX ==2,1),data(IDX ==2,2),'b.')
plot(data(IDX ==3,1),data(IDX ==3,2),'k.')
ksdensity(X,'npoints',1000,'support',[min(X) max(X)])
hold off

scatter3([ev.vr1],[ev.vr2],[ev.vr3]);