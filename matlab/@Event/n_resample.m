function [n] = n_resample(obj,id,error)
%N_RESAMPLE Summary of this function goes here
%   Detailed explanation goes here
    n = 1:obj.sensors(id).n;
    %busqueda binaria
    while(length(n)>1)
        index = floor(length(n)/2);
        new_n = n(index);        
        if(obj.error_resample(id, new_n) <= error)
            n = n(1:index);
        else
            n = n((index+1):end);
        end
    end
end

