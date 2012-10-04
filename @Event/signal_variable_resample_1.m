function sensor_out = signal_variable_resample_1( obj, id , e)
%SIGNAL_VARIABLE_RESAMPLE_2 Summary of this function goes here
%   Detailed explanation goes here

X = obj.position(id).X;
Y = obj.position(id).Y;
Z = obj.position(id).Z;
T = obj.position(id).T;

ind = [1 length(T)];

re_x = obj.position(id).X(ind);
re_y = obj.position(id).Y(ind);
re_z = obj.position(id).Z(ind);
re_t = obj.position(id).T(ind);

M = max([norm(X,obj.p) norm(Y,obj.p) norm(Z,obj.p)]);

inter_x = interp1(re_t,re_x,T);
inter_y = interp1(re_t,re_y,T);
inter_z = interp1(re_t,re_z,T);

X = obj.position(id).X-interp1(re_t,re_x,T);
Y = obj.position(id).Y-interp1(re_t,re_y,T);
Z = obj.position(id).Z-interp1(re_t,re_z,T);
error = max([(norm(obj.position(id).X-inter_x,obj.p))/M (norm(obj.position(id).Y-inter_y,obj.p))/M (norm(obj.position(id).Z-inter_z,obj.p))/M]);
while(error>e)
    ind_x = find(abs(X)==max(abs(X)));
    ind_y = find(abs(Y)==max(abs(Y)));
    ind_z = find(abs(Z)==max(abs(Z)));

    %buscamos el indice que produce el maximo
    if(max(abs(X(ind_x)))>=max(abs(Y(ind_y))) && max(abs(X(ind_x)))>=max(abs(Z(ind_z))))
        new_ind = ind_x;
    else
        if(max(abs(Y(ind_y)))>=max(abs(Z(ind_z))))
            new_ind = ind_y;
        else
            new_ind = ind_z;
        end
    end
    
    ind = unique([ ind new_ind]);
    
    re_x = obj.position(id).X(ind);
    re_y = obj.position(id).Y(ind);
    re_z = obj.position(id).Z(ind);
    re_t = obj.position(id).T(ind);
    
    X = obj.position(id).X-interp1(re_t,re_x,T);
    Y = obj.position(id).Y-interp1(re_t,re_y,T);
    Z = obj.position(id).Z-interp1(re_t,re_z,T);
    
    inter_x = interp1(re_t,re_x,T);
    inter_y = interp1(re_t,re_y,T);
    inter_z = interp1(re_t,re_z,T);
    error = max([(norm(obj.position(id).X-inter_x,obj.p))/M (norm(obj.position(id).Y-inter_y,obj.p))/M (norm(obj.position(id).Z-inter_z,obj.p))/M]);
end
obj.position(id).X = re_x;
obj.position(id).Y = re_y;
obj.position(id).Z = re_z;
obj.position(id).T = re_t;
obj.position(id).frec = diff(re_t).^(-1);
obj.position(id).period = diff(re_t);
obj.position(id).n = length(re_t);

sensor_out = obj.position(id);

end

