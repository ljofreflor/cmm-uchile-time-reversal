function obj = set_domain( obj,nx,ny,nz,nt )
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
for i = 1:obj.len
        if( obj.tmin > min(obj.gs(i).T) )
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
obj.xmin = obj.LocR(1);
obj.xmax = obj.LocR(1);
obj.ymin = obj.LocR(2);
obj.ymax = obj.LocR(2);
obj.zmin = obj.LocR(3);
obj.zmax = obj.LocR(3);

%% busqueda secuencial dado que los datos están desordenados
for i = 1:obj.len
    if(obj.xmin > obj.gss(i).x0)
        obj.xmin = obj.gss(i).x0;
    end
    if(obj.xmax < obj.gss(i).x0)
        obj.xmax = obj.gss(i).x0;
    end
    if(obj.ymin > obj.gss(i).y0)
        obj.ymin = obj.gss(i).y0;
    end
    if(obj.ymax < obj.gss(i).y0)
        obj.ymax = obj.gss(i).y0;
    end
    if(obj.zmin > obj.gss(i).z0)
        obj.zmin = obj.gss(i).z0;
    end
    if(obj.zmax < obj.gss(i).z0)
        obj.zmax = obj.gss(i).z0;
    end
end


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

