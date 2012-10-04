function obj = addGeosensor(obj, gs, data)
gs.data = data;
gs.medicionesValidas = [ ~all(data(:,1) == 0) ~all(data(:,2) == 0) ~all(data(:,3) == 0) ];
%validad si todas las direcciones tienen datos
gs.validAll = ~(all(data(:,1) == 0) || all(data(:,2) == 0) || all(data(:,3) == 0));
%agregar ese flag a la lista del evento
gs.L = length(data(:,1));
% obtener el resampleo del desplazamiento
gs = gs.variableResample(obj.error);
obj.gss = [obj.gss gs];

%actualizar el dominio para que abarque a todos los
%sensores
if(obj.first_time > min(gs.timevector))
    obj.first_time = min(gs.timevector);
end

% ventana de tiempo de captura de la senial
if(obj.last_time < max(gs.timevector))
    obj.last_time = max(gs.timevector);
end
if(obj.xi > min(gs.r0(1)))
    obj.xi = min(gs.r0(1));
end
if(obj.xf < max(gs.r0(1)))
    obj.xf = max(gs.r0(1));
end
if(obj.yi > min(gs.r0(2)))
    obj.yi = min(gs.r0(2));
end
if(obj.yf < max(gs.r0(2)))
    obj.yf = max(gs.r0(2));
end
if(obj.zi > min(gs.r0(3)))
    obj.zi = min(gs.r0(3));
end
if(obj.zf < max(gs.r0(3)))
    obj.zf = max(gs.r0(3));
end
% actualizar el dominio
% ejes
obj.x_axis = linspace(obj.xi,obj.xf,60);
obj.y_axis = linspace(obj.yi,obj.yf,60);
obj.z_axis = linspace(obj.zi,obj.zf,10);
obj.t_axis = linspace(0,1.5*(obj.last_time - obj.first_time), 50);

% diferencias de la discretizacion
obj.dx = obj.x_axis(2) - obj.x_axis(1);
obj.dy = obj.y_axis(2) - obj.y_axis(1);
obj.dz = obj.z_axis(2) - obj.z_axis(1);

obj.count = obj.count + 1;
end

