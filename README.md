Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

#Instrucciones

1 Bajar el proyecto
2 Mediante un zip
3 En alguna carpeta de su computador personal, y teniendo git instalado escribir en un terminal

```
git clone git@github.com:ljofre/cmm-uchile-time-reversal.git
```

4 Luego convertiremos los sets de datos en archivos que puedan ser utilizables desde matlab

```
cd cmm-uchile-time-reversal/python
python readFiles.py
```
Esto generará unas nuevas carpetas con la información simplificada desde los set de datos a archivos *.txt que podrán ser
leidos desde matlab, si quiere agregar nuevos eventos, ir al apartado "How To"
5 En Matlab agregar la descargada o clonada en el **Path** del sistema
6 Ejecutar los siguientes scripts de Matlab

##Obtensión de la forma de la fuente asumiendo un ubicación conocido

 ```matlab
Events = importEvents();             % Importa todos los archivos a una lista de objetos events
                  % Evento en estudio, puede ser en 1:event.count
                                     % forma de la fuente y error de estimación
nSrc = 100;
dt = .002;

n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n); 
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSrc, dt, [1:2 4:event.count]); 
plotSrc(event.origin_time, src);
% el sensor_id = 25 genera una medición extra~na

n = 2;
event = Events(n);   
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSrc, dt, [1 3:4 6:event.count]); 
plotSrc(event.origin_time, src);

n = 3;
event = Events(n);   
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSrc, dt, [2:event.count]); 
plotSrc(event.origin_time, src);
% sensor_id = 20
```

Evento
![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.source2.png?raw=true)


Evento filtrado y rotado
```
rotfiltsrc = rotate(filtsrc);
plotSrc(event.origin_time, rotfiltsrc);
```
![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.r.source2.png?raw=true)

Para obtener el vector perpendicular al plano de ruptura se puede hacer el cambio de base
mediante una matriz ortogonal que produzca máximo desplazamiento en un eje

```matlab      
[rotatesrc] = rotate(src); % fuente rotada
plotSrc(event.origin_time,rotatesrc); % mostrar cada una de las componentes con sus respectivos
                                      % porcentajes de señal en cada eje.
 ```

Y una rotación de los ejes para el campo desplazamiento filtrado
```matlab       
[rotatefiltsrc] = rotate(filtsrc);
plotSrc(event.origin_time,rotatefiltsrc);
 ```
fuente
![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/source1.png?raw=true)

fuente filtrada
![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.source1.png?raw=true)

fuente filtrada y rotada
![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.r.source1.png?raw=true)

![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.source1.png?raw=true)

![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.source10.png?raw=true)

![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/f.source11.png?raw=true)

En el cual veremos el campo de desplazamiento



## Estimación de la fuente dado un conjunto arbitrario de sensores

```matlab
index = [1:4 6:14];                         % conjunto de sensores que se quieren usar
[src, cutsrc, filtsrc, filtcutsrc, error] = sourceOneSensor(event, nSrc, dt, index); 
[rotsrc] = rotate(src);
plotSrc(event.origin_time, rotsrc);
```

## Estimación de la fuente dado un sensor y reestimacion de dicho sensor mediante esa fuente
Para ver la validez de una fuente estimada se espera que sensores estimados dado dicha fuente
sean parecidos a la medicion de los sensores reales

```matlab
clear('dataGsRec')
clear('dataGsReal')
index = [1];                         % conjunto de sensores que se quieren usar
[src, cutsrc, filtsrc, filtcutsrc, error] = sourceOneSensor(event, nSrc, dt, index); 
[dataGsRec, dataGsReal, errorL2] = recon(event, index, src);

```

- - -




## Reconstrucción de un sensor para una fuente con el error de estimación
Ya con los eventos cargados y una fuente estimada, podemos reestimar cada 
uno de los sensores mediante dicha fuente.

```matlab
clear('dataGsRec')
clear('dataGsReal')
% reconstrucción de un sensor y el error de estimación
for index = 1:event.count
    % se obtiene de cada sensor la estimación
    [dataGsRec{index}, dataGsReal{index}, errorL2] = recon(event, index, src);
end
```
Si repetimos el procedimiento para cada uno de los sensores, obtenemos los 
siguientes gráficos


##Filtro optimo
Se espera que después del filtro la rotación de la señal tenga una cantidad mínima 
de esta en uno de sus ejes. el La frecuencia de corte será entonces la que produzca que
ese porcentaje sea mínimo.

## Inversión de la señal
Para obter la señal invertida en el dominio que contiene a todos los sensores
con una resolución arbitraria ( definir resolución optima ).

```matlab
[X, Y, Z] = sensor.reverse_signal();
```
- - -

##Pruebas de validez del código 
 
Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.
### Prueba sobre la estimación numerica de la fuente por medio de mínimos cuadrados
Se crea un evento con sensores que captan un evento sísmico imposible, solo
con el objetivo de ver la capacidad del modelo de reconstruir esa fuente.

```matlab
art = eventoArtificial(event);
nSrc = 250;
dt = 2/4800;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(art, nSrc, dt);

```

![Sin titulo](https://github.com/ljofre/cmm-uchile-time-reversal/blob/master/fig/test-plot.png?raw=true)
### Pruebas sobre la inversión de una señal sintética




## Busqueda del punto de ruptura
En cada ubicación r0 que se asume como candidato a un epicentro sísmico, ocurre
un error de estimación, se buscará entonces, dado un dominio dado, encontrar la ubicación
que produzca una estimación de mínimo error.

#How To

##Agregar nuevos set de datos a los existentes
