%busqueda del punto de concentracion
clear;
% mu(1).reset
import_all;

pp = 1;
%%-------------------------------------------------------------------------
for j = 1:10
    % problemas
    test = copyobj2(mu(pp));
    if j ~= 1
            test.LocR = [x y z];
    end
    
    for i = 1:test.count
        dist = norm(test.LocR - test.gss(i).r0);
        test.gss(i).r_x = test.gss(i).r_x*dist^2;
        test.gss(i).r_x = test.gss(i).r_y*dist^2;
        test.gss(i).r_x = test.gss(i).r_z*dist^2;
    end
    
    [ X Y Z ] = test.reverse_signal;
    
    u = zeros(1,length(test.t_axis));
    d = zeros(1,length(test.t_axis));
    
    for ii = 1:length(d)
        d(ii) = NaN;
    end
    
    U = sqrt(X.^2+Y.^2+Z.^2);
    
    xii = test.X_domain(:,:,:,1);
    yii= test.Y_domain(:,:,:,1);
    zii = test.Z_domain(:,:,:,1);
    
    path = [];
    for ii = 1:1:length(test.t_axis)
        u = U(:,:,:,ii);
        ind = find(u == max(u(:)));
        if length(ind)==1
            [sub_x sub_y sub_z] = ind2sub(size(u),ind);
            
            path = [path;sub_x sub_y sub_z];
            x =  xii(sub_x,sub_y,sub_z);
            y =  yii(sub_x,sub_y,sub_z);
            z =  zii(sub_x,sub_y,sub_z);
            d(ii) = norm(test.LocR-[x y z],2);
        else
             path = [path;NaN NaN NaN];
        end
       
    end
    kk = find(d == min(d));
    newLocR = path(kk,:);
    x =  xii(path(kk,1),path(kk,2),path(kk,3));
    y =  yii(path(kk,1),path(kk,2),path(kk,3));
    z =  zii(path(kk,1),path(kk,2),path(kk,3));    
end

