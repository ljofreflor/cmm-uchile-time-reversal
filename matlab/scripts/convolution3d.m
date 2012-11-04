function result = convolution3d(kerX, kerY, kerZ,ux,uy,uz,dt)
%CONVOLUTION3D convolucion en tres dimensiones

result = (ifft(fft(kerX).*fft(ux)) + ...
            ifft(fft(kerY).*fft(uy)) + ...
            ifft(fft(kerZ).*fft(uz)))*dt;
end

