%clear; import_all;
data = detrend(cumsum(mu(1).gss(1).data));
n = size(data);
n = n(1);
Fs = 1/mu(1).gss(1).hardware_sampling_rate;
L = length(data(:,1));

x = data(:,1);
y = data(:,2);
z = data(:,3);

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y(:,1) = fft(x,NFFT)/L;
Y(:,2) = fft(y,NFFT)/L;
Y(:,3) = fft(z,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
tr = 2*abs(Y(1:NFFT/2+1,1));
plot(f,tr);
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

% al calcular la matriz de covariazan y sus vecotres propios

covy = cov(Y);
[v,e] = eig(covy);

Z = zeros(n,3);
v = real(v);
for ii = 1:n
    Z(ii,1) = data(ii,1)*v(1,1) + data(ii,2)*v(2,1) + data(ii,3)*v(3,1);
    Z(ii,2) = data(ii,1)*v(1,2) + data(ii,2)*v(2,2) + data(ii,3)*v(3,2);
    Z(ii,3) = data(ii,1)*v(1,3) + data(ii,2)*v(2,3) + data(ii,3)*v(3,3);
end
plot(Z(:,3))


