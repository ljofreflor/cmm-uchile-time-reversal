function [data, src] = datosArticiales(sens,t0,r0,alpha,beta,rho)
%datos artificiales creados generados por una fuente con forma de impulsos
%cuadrados.

% tiempo sincronizado para convolucionar
sinctime = linspace(min([t0 sens.timevector(1)]) ,sens.timevector(end),sens.L);

% fuente escalonada
src = zeros([sens.L 3]);

src(10:20,2) = 1;
src(25:35,1) = 1;
src(40:50,3) = 1;

% convolucionar la fuente con la funcion de green para obtener el sensor
% estimado.
r = sens.r0;
x = r(1) - r0(1);
y = r(2) - r0(2);
z = r(3) - r0(3);
[G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(x, y, z, sinctime - t0, alpha, beta, rho);

% diferencial de tiempo
dt = sinctime(2) - sinctime(1);

% aplicando el teo. de la convolucion
data(:,1) = (ifft(fft(G11').*fft(src(:,1))) + ...
            ifft(fft(G12').*fft(src(:,2))) + ...
            ifft(fft(G13').*fft(src(:,3))))*dt;

data(:,2) = (ifft(fft(G12').*fft(src(:,1))) + ...
            ifft(fft(G22').*fft(src(:,2))) + ...
            ifft(fft(G23').*fft(src(:,3))))*dt;

data(:,3) = (ifft(fft(G13').*fft(src(:,1))) + ...
            ifft(fft(G23').*fft(src(:,2))) + ...
            ifft(fft(G33').*fft(src(:,3))))*dt;
        
% aplicando convoluci'on como integral
data(:,1) = (convolution(G11',src(:,1)) + ...
            convolution(G12',src(:,2)) + ...
            convolution(G13',src(:,3)))*dt;
        
data(:,2) = (convolution(G12',src(:,1)) + ...
            convolution(G22',src(:,2)) + ...
            convolution(G23',src(:,3)))*dt;

data(:,3) = (convolution(G13',src(:,1)) + ...
            convolution(G23',src(:,2)) + ...
            convolution(G33',src(:,3)))*dt;
% se obtiene con los dos metodos el mismo resultado

% se convierten los datos a la escala de tiempo del sensor
data = interp1(sinctime', data, sens.timevector);
% en oportunidades, el tiempo de origen es posterior a la primera medici'on
% por lo que aparecen valores NaN en la interpolaci`on.
data(isnan(data)) = 0;
src = horzcat(sinctime', src);

end