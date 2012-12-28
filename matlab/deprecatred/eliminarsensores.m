% podemos considerar que los sensores mas cercanos son aquellos que
% producen fuentes mas parecidad, ese es un 
%criterio para eliminar sensores
% inconsistentes o que dan malas mediciones.

srcs = [];
n = 5;

for ii = 1:Ev(n).count
    temp = Ev(n);
    temp.gss = Ev(n).gss(ii);
    src = source(temp,200, 0.5,0.09);
    srcs = horzcat(srcs,src(:));
end

% Hacemos la clasificacion de las fuentes

% el numero de clusters se puede obtener como aquel que minimice el error
% generalizado.

[IDX] = kmeans(srcs',3);

% evento temporal en el que solo se consideraran los sensores que generen
% fuentes parecidas. Esto se hace para poder eliminar los sismografos con
% mediciones extran~as.
temp = Ev(n);
temp.gss = Ev(n).gss(IDX == mode(IDX));
[temp.src, temp.filtsrc] = source(temp,200, 0.5,0.09);

% graficas de sensor estimado
figure;
plotSrc(temp);
figure;
plotFiltSrc(temp);
figure;
plotRotFiltSrc(temp);

