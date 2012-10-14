Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

#Instrucciones

1 Bajar el proyecto
1.1 Mediante un zip
1.2 En alguna carpeta de su computador personal, y teniendo git instalado escribir en un terminal

```
git clone git@github.com:ljofre/cmm-uchile-time-reversal.git
```

2. Luego convertiremos los sets de datos en archivos que puedan ser utilizables desde matlab

```
cd cmm-uchile-time-reversal/python
python readFiles.py
```
Esto generará unas nuevas carpetas con la información simplificada desde los set de datos a archivos *.txt que podrán ser
leidos desde matlab, si quiere agregar nuevos eventos, ir al apartado "How To"
3. En Matlab agregar la descargada o clonada en el **Path** del sistema
4. Ejecutar los siguientes scripts de Matlab

##Obtensión de la forma de la fuente asumiendo un ubicación conocido

 ```
Events = importEvents();             % Importa todos los archivos a una lista de objetos events
n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n);                   % Evento en estudio, puede ser en 1:event.count
                                     % forma de la fuente y error de estimación
nSrc = 200;
dt = .0005;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSrc, dt); 
```

Para obtener el vector perpendicular al plano de ruptura se puede hacer el cambio de base
mediante una matriz ortogonal que produzca máximo desplazamiento en un eje

```        
[rotatesrc,N1,N2,N3] = rotate(src)
plot(rotatesrc);
 ```

Y una rotación de los ejes para el campo desplazamiento filtrado
```        
[rotatefiltsrc,N1,N2,N3] = rotate(filtsrc)
plot(rotatefiltsrc);
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


- - -

## Reconstrucción de un sensor para una fuente con el error de estimación
Ya con los eventos cargados y una fuente estimada, podemos reestimar cada 
uno de los sensores mediante dicha fuente.

```
clear('dataGsRec')
clear('dataGsReal')
% reconstrucción de un sensor y el error de estimación
for m = 1:event.count
    gs = event.gss(m);

    % se obtiene de cada sensor la estimación
    [dataGsRec{m}, dataGsReal{m}, errorL2] = recon(event, gs, src);
end
```
Si repetimos el procedimiento para cada uno de los sensores, obtenemos los 
siguientes gráficos



## Inversión de la señal
Para obter la señal invertida en el dominio que contiene a todos los sensores
con una resolución arbitraria ( definir resolución optima ).

```
[X, Y, Z] = sensor.reverse_signal();
```
- - -

##Pruebas de validez del código 
 
Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.
### Prueba sobre la estimación numerica de la fuente por medio de mínimos cuadrados
Se crea un evento con sensores que captan un evento sísmico imposible, solo
con el objetivo de ver la capacidad del modelo de reconstruir esa fuente.

```
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
