ev = 1;
sen = 7;

data = mu(ev).gss(sen).data;

n = size(data);
n = n(1);
% matriz de correlacion de los datos
c = cov(data);
% v los vectores propios
[v,e]=eig(c);
% obteniendo los vectores propios, se hace el cambio de base desde los ejes
% canonicos a los vectores propios.
Z = zeros(n,3);
v = real(v);

for ii = 1:n
    Z(ii,1) = data(ii,1)*v(1,1) + data(ii,2)*v(2,1) + data(ii,3)*v(3,1);
    Z(ii,2) = data(ii,1)*v(1,2) + data(ii,2)*v(2,2) + data(ii,3)*v(3,2);
    Z(ii,3) = data(ii,1)*v(1,3) + data(ii,2)*v(2,3) + data(ii,3)*v(3,3);
end

x = Z(:,1);
y = Z(:,2);
z = Z(:,3);
plot(y+z);