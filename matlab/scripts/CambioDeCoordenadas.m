%import_all;
function  Z1 = CambioDeCoordenadas(mu,i,j,k)
data = detrend(cumsum(mu(i).gss(j).data));
n = size(data);
n = n(1);
[v,e]=eig(cov(data));
Z1 = zeros(n,3);
for ii = 1:n
    Z1(ii,1) = data(ii,1)*v(1,1) + data(ii,2)*v(2,1) + data(ii,3)*v(3,1);
    Z1(ii,2) = data(ii,1)*v(1,2) + data(ii,2)*v(2,2) + data(ii,3)*v(3,2);
    Z1(ii,3) = data(ii,1)*v(1,3) + data(ii,2)*v(2,3) + data(ii,3)*v(3,3);
end

%pasarlo a cordenadas canonicas

plot(Z1(:,k));
end