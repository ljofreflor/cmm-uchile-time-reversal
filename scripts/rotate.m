function [rotatesrc,N1,N2,N3] = rotate(src)
data = src(:,2:4);
n = size(data,1);

% matriz de correlacion de los datos
c = cov(data);
% v los vectores propios
[v,e] = eig(c);

% obteniendo los vectores propios, se hace el cambio de base desde los ejes
% canonicos a los vectores propios.
rotatesrc = zeros(n,3);

rotatesrc(:,1) = data(:,1)*v(1,1) + data(:,2)*v(2,1) + data(:,3)*v(3,1);
rotatesrc(:,2) = data(:,1)*v(1,2) + data(:,2)*v(2,2) + data(:,3)*v(3,2);
rotatesrc(:,3) = data(:,1)*v(1,3) + data(:,2)*v(2,3) + data(:,3)*v(3,3);


% M = sum(data(:).^2);

n1 = norm(rotatesrc(:,1),2);
n2 = norm(rotatesrc(:,2),2);
n3 = norm(rotatesrc(:,3),2);

N1 = n1/(n1+n2+n3);
N2 = n2/(n1+n2+n3);
N3 = n3/(n1+n2+n3);

end

