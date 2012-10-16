function [rotatesrc] = rotate(src)
data = src(:,2:4);
n = size(data,1);

% matriz de correlacion de los datos
c = cov(data);
% v los vectores propios
[v,e] = eig(c);

% obteniendo los vectores propios, se hace el cambio de base desde los ejes
% canonicos a los vectores propios.
rotatesrc = zeros(n,4);

% dimension temporal
rotatesrc(:,1) = src(:,1);

% dimensiones espaciales rotadas
rotatesrc(:,2) = data(:,1)*v(1,1) + data(:,2)*v(2,1) + data(:,3)*v(3,1);
rotatesrc(:,3) = data(:,1)*v(1,2) + data(:,2)*v(2,2) + data(:,3)*v(3,2);
rotatesrc(:,4) = data(:,1)*v(1,3) + data(:,2)*v(2,3) + data(:,3)*v(3,3);

end

