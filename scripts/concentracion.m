% distancia del punto de maxima concentracion en el
% y la ubicacion real

[ X ,Y ,Z ,X_domain ,Y_domain ,Z_domain ,T_domain] = mu(1).test_with_real_locations_adjusted;

u = zeros(1,length(mu(1).t_axis));
d = 1:length(mu(1).t_axis);
for i = 1:length(mu(1).t_axis);
d(i) = NaN;
end

xd = X_domain(:,:,:,1);
yd = Y_domain(:,:,:,1);
zd = Z_domain(:,:,:,1);

for i = 1:1:length(mu(1).t_axis)
    U = sqrt(X.^2+Y.^2+Z.^2);
    u = U(:,:,:,i);   
    ind = find(u == max(u(:)));
    if length(ind)==1
        [sub_x ,sub_y ,sub_z] = ind2sub(size(u),ind);
        [sub_x sub_y sub_z];
        x =  xd(sub_x,sub_y,sub_z);
        y =  yd(sub_x,sub_y,sub_z);
        z =  zd(sub_x,sub_y,sub_z);
        d(i) = norm(mu(1).LocR-[x y z],2);
    end
end

plot(d)
