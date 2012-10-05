Proyecto con la estimación de la fuente por medio del conjunto de set de datos
entregados por codelco:

#Instrucciones

1. Bajar el proyecto mediante un archivo zip o crear un clone del proyecto
2. Ejecutar el script

 ```
mu = ImportEvents(); % Importar eventos
ev = 1               % Número del evento que se desea estimar la forma de la fuente
src = source(mu, ev);% forma de la fuente
 ```