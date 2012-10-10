Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

#Instrucciones

1. Bajar el proyecto mediante un archivo zip o crear un clone del proyecto
2. En Matlab agregar la descargada o clonada en el **Path** del sistema
3. Ejecutar los siguientes scripts de Matlab

##Obtensión de la forma de la fuente asumiendo un punto conocido

 ```
Events = importEvents();             % Importa todos los archivos a una lista de objetos events
n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n);                   % Evento en estudio, puede ser en 1:event.count
                                     % forma de la fuente y error de estimación
nSync = 750;
nSrc = 250;
dt = 0.0000025;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSync, nSrc, dt); 
```
Para obtener el vector perpendicular al plano de ruptura se puede hacer el cambio de base
mediante una matriz ortogonal que produzca máximo desplazamiento en un eje

```        
[rotateSrc , B] = ChangeOfBasis(src) % rotación del campo de desplazamiento de la fuente
                                     % para encontrar el plano de ruptura y la matriz de cambio de base B
plot(rotateSrc);
 ```
En el cual veremos el campo de desplazamiento

## Reconstrucción de un sensor para una fuente con el error de estimación

```
Events = importEvents();             % Importa todos los archivos a una lista de objetos events
n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n);                   % Evento en estudio, puede ser en 1:event.count
                                     % forma de la fuente y error de estimación
nSync = 750;
nSrc = 250;
dt = 0.0000025;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSync, nSrc, dt);

% reconstrucci`on de un sensor y el error de estimaci'on
m = 3;
gss = event.gss(m);
[srcRec, error] = recon(event, gss, src);
```

## Inversión de la señal
Para obter la señal invertida en el dominio que contiene a todos los sensores
con una resolución arbitraria ( definir resolución optima ).

```
[X, Y, Z] = sensor.reverse_signal();
```

##Pruebas de validez del código 
 
Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.
### Prueba sobre la estimación numerica de la fuente por medio de mínimos cuadrados
Se crea un evento con sensores que captan un evento sísmico imposible, solo
con el objetivo de ver la capacidad del modelo de reconstruir esa fuente.

```
art = eventoArtificial(event);
nSync = 750;
nSrc = 250;
dt = 0.0000025;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(art, nSync, nSrc, dt);

```
### Pruebas sobre la inversión de una señal sintética




## Busqueda del punto de ruptura
