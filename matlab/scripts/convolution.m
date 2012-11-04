function res = convolution(ker, u)
%CONVOLUTION convolución discreta que aproxima el valor de una convolución
% continua.

% resultado de la convoluci'on
res = zeros(size(ker));

% convoluci'on discreta
for t = 1:length(res)
    res(t) = sum(ker(t + 1 - (1:t)).*u(1:t));
end 

end

