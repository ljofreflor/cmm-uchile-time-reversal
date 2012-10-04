function sensor = signal_const_resample(obj,id,n_res)
sensor = obj.sensors(id);
%nuevo tiempo de sincronizaci�n
tmin = min(obj.sensors(id).T);
tmax = max(obj.sensors(id).T);
time_sync = linspace(tmin,tmax,n_res);
% interpolaciones sobre el dominio unificado
sensor.X = interp1(obj.sensors(id).T,obj.sensors(id).X,time_sync);
sensor.Y = interp1(obj.sensors(id).T,obj.sensors(id).Y,time_sync);
sensor.Z = interp1(obj.sensors(id).T,obj.sensors(id).Z,time_sync);
sensor.T = time_sync;
sensor.n = length(time_sync);
sensor.frec = (diff(sensor.T)).^(-1);
sensor.period = sensor.frec.^(-1);
end

