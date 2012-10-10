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
gss = event.gss(1);
[srcRec, error] = recon(event, gss, src);
```

##Pruebas de validez del código 
 
Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.
### Prueba sobre la estimación numerica de la fuente por medio de mínimos cuadrados
### Pruebas sobre la inversión de una señal sintética


## Inversión de la señal

## Busqueda del punto de ruptura
