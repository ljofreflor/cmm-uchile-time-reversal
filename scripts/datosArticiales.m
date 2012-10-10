function data = datosArticiales(sens,t0,r0,alpha,beta,rho, sincn)
%datos artificiales creados generados por una fuente escalonada

hsr = sens.hardware_sampling_rate;
time = sens.timevector(1) + (0:(size(sens.data,1)-1))/hsr;
sinctime = linspace(t0,time(end),sincn);

% fuente escalonada
src = zeros([sincn 3]);

src(10:20,2) = 1;
src(25:35,1) = 1;
src(40:50,3) = 1;

% convolucionar la fuente con la funcion de green para obtener el sensor
% estimado.
r = sens.r0;
x = r(1)-r0(1);
y = r(2)-r0(2);
z = r(3)-r0(3);
[G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(x,y,z,sinctime - t0,alpha,beta,rho);

% aplicando el teo. de la convolucion
data(:,1) = ifft(fft(G11').*fft(src(:,1))) + ...
    ifft(fft(G12').*fft(src(:,2))) + ...
    ifft(fft(G13').*fft(src(:,3)));

data(:,2) = ifft(fft(G12').*fft(src(:,1))) + ...
    ifft(fft(G22').*fft(src(:,2))) + ...
    ifft(fft(G23').*fft(src(:,3)));

data(:,3) = ifft(fft(G13').*fft(src(:,1))) + ...
    ifft(fft(G23').*fft(src(:,2))) + ...
    ifft(fft(G33').*fft(src(:,3)));

data = data';

end