function obj = set_domain_center(obj, n)
%INITIAL_DOMAIN_CENTER Summary of this function goes here
%   Detailed explanation goes here
obj.x_axis = linspace(obj.LocR(1)-50,obj.LocR(1)+50,2*n);
obj.y_axis = linspace(obj.LocR(2)-50,obj.LocR(2)+50,2*n);
obj.z_axis = linspace(obj.LocR(3)-50,obj.LocR(3)+50,2*n);

%% frecuencia máxima
F = 0;
for i = 1:obj.len
    if(F < max(obj.gss(i).resampling_rate))
        F = max(obj.gss(i).resampling_rate);
    end
end

obj.t_axis = linspace(obj.tau-obj.origin_time-n/F,obj.tau-obj.origin_time+n/F,2*n);

[obj.xdim, obj.ydim, obj.zdim, obj.tdim] = ndgrid(obj.x_axis,obj.y_axis,obj.z_axis,obj.t_axis);

%% valores secundarios

% diferenciales
obj.dx = obj.x_axis(2)-obj.x_axis(1);
obj.dy = obj.y_axis(2)-obj.y_axis(1);
obj.dz = obj.z_axis(2)-obj.z_axis(1);
obj.dt = obj.t_axis(2)-obj.t_axis(1);

% tamaño de los ejes
obj.nx = length(obj.x_axis);
obj.ny = length(obj.y_axis);
obj.nz = length(obj.z_axis);
obj.nt = length(obj.t_axis);

end

