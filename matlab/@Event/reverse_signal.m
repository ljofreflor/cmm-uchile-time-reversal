function [X, Y, Z, X_domain, Y_domain, Z_domain, T_domain] = reverse_signal( obj )
%REVERSE_SIGNAL Retorna la se~nal invertida por medio de time reversal, el
%parametro que
[obj.X_domain, obj.Y_domain, obj.Z_domain, obj.T_domain] = ndgrid(obj.x_axis,obj.y_axis,obj.z_axis,obj.t_axis);
X = zeros(size(obj.X_domain));
Y = X;
Z = X;

% se van acumulando 1 por una las señales invertidas de cada uno se los
% sensores en el dominio para formar cada una de las componentes de la
% señal invertida (X,Y,Z).

valid = [obj.gss.validAll];
range = find(valid == 1);
for ii = range
    fprintf('%d sensores de %d totales validos de %d ...\n', ii, ...
        sum(valid),length(range));
    [X_TEMP,Y_TEMP,Z_TEMP] = obj.field(ii);
    X = X + X_TEMP;
    Y = Y + Y_TEMP;
    Z = Z + Z_TEMP;
end

X_domain = obj.X_domain;
Y_domain = obj.Y_domain;
Z_domain = obj.Z_domain;
T_domain = obj.T_domain;
end

