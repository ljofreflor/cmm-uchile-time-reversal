% distancia del punto de maxima concentracion en el
% y la ubicacion real
% clear; clear;
% import_all;
p = 1;
for i = 1:mu(p).count
    mu(p).gss(i).r_x = mu(p).gss(i).r_x*(mu(p).gss(i).dis_to_src)^2;
    mu(p).gss(i).r_y = mu(p).gss(i).r_y*(mu(p).gss(i).dis_to_src)^2;
    mu(p).gss(i).r_z = mu(p).gss(i).r_z*(mu(p).gss(i).dis_to_src)^2;
end
[ X, Y, Z ] = mu(p).reverse_signal;

u = zeros(1,length(mu(p).t_axis));
d = zeros(1,length(mu(p).t_axis));

for ii = 1:length(d)
    d(ii) = NaN;
end

xd = mu(p).X_domain(:,:,:,1);
yd = mu(p).Y_domain(:,:,:,1);
zd = mu(p).Z_domain(:,:,:,1);

U = sqrt(X.^2+Y.^2+Z.^2);
for i = 1:1:length(mu(p).t_axis)    
    u = U(:,:,:,i);    
    path = [];
    ind = find(u == max(u(:)));
    if length(ind)==1
        [sub_x, sub_y, sub_z] = ind2sub(size(u),ind);
        path = [path;sub_x sub_y sub_z];
        x =  xd(sub_x,sub_y,sub_z);
        y =  yd(sub_x,sub_y,sub_z);
        z =  zd(sub_x,sub_y,sub_z);
        d(i) = norm(mu(p).LocR-[x y z],2);
    end
end

plot(d);
axis([1 length(d) 0 max(d)]);