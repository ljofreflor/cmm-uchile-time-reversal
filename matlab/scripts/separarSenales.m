data = mu(1).gss(1).data;

Fs = 1/mu(1).gss(1).hardware_sampling_rate;
VsubX = data(:,1);
VsubY = data(:,2);
VsubZ = data(:,3);
L = length(VsubX);


NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(VsubX,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
tr = 2*abs(VsubX(1:NFFT/2+1));
plot(f,tr);
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

