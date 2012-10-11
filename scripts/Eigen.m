
data = src(:,2:4);
filterdata = filtsrc(:,2:4);
data = detrend(data);
filterdata = detrend(filterdata);

n = size(data,1);
fn = size(filterdata,1);
% matriz de correlacion de los datos
c = cov(data);
fc = cov(filterdata);
% v los vectores propios
[v,e] = eig(c);
[fv,fe] = eig(fc);
% obteniendo los vectores propios, se hace el cambio de base desde los ejes
% canonicos a los vectores propios.
Z = zeros(n,3);
filterZ = Z;

v = real(v);


Z(:,1) = data(:,1)*v(1,1) + data(:,2)*v(2,1) + data(:,3)*v(3,1);
Z(:,2) = data(:,1)*v(1,2) + data(:,2)*v(2,2) + data(:,3)*v(3,2);
Z(:,3) = data(:,1)*v(1,3) + data(:,2)*v(2,3) + data(:,3)*v(3,3);

filterZ(:,1) = filterdata(:,1)*fv(1,1) + filterdata(:,2)*fv(2,1) + filterdata(:,3)*fv(3,1);
filterZ(:,2) = filterdata(:,1)*fv(1,2) + filterdata(:,2)*fv(2,2) + filterdata(:,3)*fv(3,2);
filterZ(:,3) = filterdata(:,1)*fv(1,3) + filterdata(:,2)*fv(2,3) + filterdata(:,3)*fv(3,3);



M = sum(data(:).^2);
filterM = sum(filterdata(:).^2);

n1 = norm(Z(:,1),2);
n2 = norm(Z(:,2),2);
n3 = norm(Z(:,3),2);

fn1 = norm(filterZ(:,1),2);
fn2 = norm(filterZ(:,2),2);
fn3 = norm(filterZ(:,3),2);

fN1 = fn1/(fn1 + fn2 + fn3);
fN2 = fn2/(fn1 + fn2 + fn3);
fN3 = fn3/(fn1 + fn2 + fn3);

Z = filterZ;
subplot(1,3,1);
plot(src(:,1),Z(:,1))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);

subplot(1,3,2);
plot(src(:,1),Z(:,2))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);

subplot(1,3,3);
plot(src(:,1),Z(:,3))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);

