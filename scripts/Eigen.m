
data = src(:,2:4);
data = detrend(data);

n = size(data,1);
% matriz de correlacion de los datos
c = cov(data);
% v los vectores propios
[v,e] = eig(c);
% obteniendo los vectores propios, se hace el cambio de base desde los ejes
% canonicos a los vectores propios.
Z1 = zeros(n,3);

v = real(v);

for ii = 1:n
    Z1(ii,1) = data(ii,1)*v(1,1) + data(ii,2)*v(2,1) + data(ii,3)*v(3,1);
    Z1(ii,2) = data(ii,1)*v(1,2) + data(ii,2)*v(2,2) + data(ii,3)*v(3,2);
    Z1(ii,3) = data(ii,1)*v(1,3) + data(ii,2)*v(2,3) + data(ii,3)*v(3,3);
end

M = sum(data(:).^2);

subplot(1,3,1);
plot(src(:,1),Z1(:,1))
axis([min(src(:,1)) max(src(:,1)) min(Z1(:)) max(Z1(:))]);

subplot(1,3,2);
plot(src(:,1),Z1(:,2))
axis([min(src(:,1)) max(src(:,1)) min(Z1(:)) max(Z1(:))]);

subplot(1,3,3);
plot(src(:,1),Z1(:,3))
axis([min(src(:,1)) max(src(:,1)) min(Z1(:)) max(Z1(:))]);

