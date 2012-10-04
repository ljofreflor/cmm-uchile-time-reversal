function error = error_resample(obj, id, n_resample)

X = obj.sensors(id).X;
Y = obj.sensors(id).Y;
Z = obj.sensors(id).Z;
T = obj.sensors(id).T;

sensor_temp = obj.signal_const_resample(id, n_resample);
%deducir reales valores desde valores remuestreados
deducX = interp1(sensor_temp.T, sensor_temp.X, T);
deducY = interp1(sensor_temp.T, sensor_temp.Y, T);
deducZ = interp1(sensor_temp.T, sensor_temp.Z, T);
%almacenamos cada uno de los errores.
error1 = norm(deducX-X,obj.p);
error2 = norm(deducY-Y,obj.p);
error3 = norm(deducZ-Z,obj.p);
%considerar el maximo de los errores producidos
error = max([error1,error2,error3])/obj.sensors(id).max_norm;
end

