Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

contacto: ljofre2146@gmail.com

#Instrucciones

1. Bajar el proyecto mediante un archivo zip o crear un clone del proyecto
2. Agregar la carpeta descargada en el **Path** de Matlab
3. Ejecutar los siguientes scripts en matlab


##Obtensión de la forma de la fuente asumiendo un punto conocido

 ```
Events = importEvents();             % Importa todos los archivos a una lista de objetos events
n = 1;                               % Número del evento que se desea estimar la forma de la fuente
event = Events(n);                   % Evento en estudio, puede ser en 1:event.count
                                     % forma de la fuente y error de estimación
[src, cutsrc, filtsrc, cutfiltsrc, error] = source(event);  
```
Para obtener el vector perpendicular al plano de ruptura se puede hacer el cambio de base
mediante una matriz ortogonal que produzca máximo desplazamiento en un eje

```        
[rotateSrc , B] = ChangeOfBasis(src) % rotaci'on del campo de desplazamiento de la fuente
                                     % para encontrar el plano de ruptura y la matriz de cambio de base B
plot(rotateSrc);
 ```
En el cual veremos el campo de desplazamiento

##Pruebas de validez del código 
 
Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.
### Prueba sobre la estimación numerica de la fuente por medio de mínimos cuadrados
### Pruebas sobre la inversión de una señal sintética


###
 
 