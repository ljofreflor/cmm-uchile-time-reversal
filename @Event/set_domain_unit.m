function obj = set_domain_unit( obj,nx,ny,nz,nt )
%INITIALDOMAIN Summary of this function goes here

%   Detailed explanation goes here

obj.nx = nx;
obj.ny = ny;
obj.nz = nz;
obj.nt = nt;

%% intervalo de tiempo

%adivinanza inicial
obj.tmax = obj.origin_time;
obj.tmin = obj.origin_time;
%for each sensor in obj.gss
for i = 1:obj.count
        if( obj.tmin > min(obj.gss(i).T) )
            obj.tmin = min(obj.gss(i).T);
        end
        if( obj.tmax < max(obj.gss(i).T) )
            obj.tmax = max(obj.gss(i).T);
        end
        % este intervalo debe considerar el tiempo estimado en que ocurre
        % el evento
end

%% encontrar las aristas del primer estimado de dominio
%adivinanza inicial
obj.xmin = 0;
obj.xmax = 1;
obj.ymin = 0;
obj.ymax = 1;
obj.zmin = 0;
obj.zmax = 1;


% ejes 
obj.x_axis = linspace(obj.xmin,obj.xmax,obj.nx);
obj.y_axis = linspace(obj.ymin,obj.ymax,obj.ny);
obj.z_axis = linspace(obj.zmin,obj.zmax,obj.nz);
obj.t_axis = linspace(obj.tmin,obj.tmax,obj.nt);

[obj.xdim obj.ydim obj.zdim obj.tdim] = ndgrid(obj.x_axis,obj.y_axis,obj.z_axis,obj.t_axis);


% valores recundarios
obj.dx = obj.x_axis(2)-obj.x_axis(1);
obj.dy = obj.y_axis(2)-obj.y_axis(1);
obj.dz = obj.z_axis(2)-obj.z_axis(1);

end

