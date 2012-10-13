function obj = FindMaxNorm( obj )
%FINDMAXNORM Summary of this function goes here
%   Detailed explanation goes here
obj.MaxNorm = 0;
for i = 1:obj.length
    tempNorm = max([ norm(obj.sensors(i).medicion.X) norm(obj.sensors(i).medicion.Y)  norm(obj.sensors(i).medicion.Z)  ]);
    if(tempNorm>obj.MaxNorm)
        obj.MaxNorm = tempNorm;
    end
end
end

