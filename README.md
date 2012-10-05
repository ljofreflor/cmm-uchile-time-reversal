Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

#Instrucciones

1. Bajar el proyecto mediante un archivo zip o crear un clone del proyecto
2. En matlab agregar la carpeta del clone en la path
3. Ejecutar el script en matlab

##Obtensión de la forma de la fuente asumiendo un punto conocido

 ```
mu = ImportEvents();                 % Importar eventos
ev = 1;                              % Número del evento que se desea estimar la forma de la fuente
[src, error] = source(mu, ev);       % forma de la fuente y error de estimación
[rotateSrc , B] = ChangeOfBasis(src) % rotaci'on de la fuente sísmica 
                                      % para encontrar el plano de ruptura y la matriz de cambio de base B
plot(rotateSrc);
 ```
En el cual veremos el campo de desplazamiento

 ##Pruebas de validez del código
 
 Este framework consta de una serie de pruebas que validan la integridad numérica de los resultados de las mediciones reales.