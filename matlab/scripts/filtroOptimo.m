function rfsrc = filtroOptimo(source)
%FILTROOPTIMO filtro que produce que la rotacion genere un vector lo mas
%perpendicular posible al desplazamiento
src = source;
n = size(src,1);
L = 2^nextpow2(size(src,1));
intersrc = interp1(1:n,src, linspace(1,n,L));
% eliminar frecuencias bajas
for ii = 1:(L/2)
    fftsrc = fft(intersrc);
    %eliminar frecuencias bajas
    fftsrc([1:1:ii L:-1:(L-ii+1)],:) = 0;
    % rotar ejes
    rfsrc = rotate(real(ifft(fftsrc)));
    % calcular porcentaje de la señal en el eje menor
    p1 = norm(rfsrc(:,2))/(norm(rfsrc(:,2)) + norm(rfsrc(:,3)) + norm(rfsrc(:,4)));
    p2 = norm(rfsrc(:,3))/(norm(rfsrc(:,2)) + norm(rfsrc(:,3)) + norm(rfsrc(:,4)));
    p3 = norm(rfsrc(:,4))/(norm(rfsrc(:,2)) + norm(rfsrc(:,3)) + norm(rfsrc(:,4)));
    % almacenar porcentaje
    per1(ii) = p1;
    per2(ii) = p2;
    per3(ii) = p3;
end

% seleccion de la frecuencia
ii = 26;
fftsrc = fft(intersrc);
%eliminar frecuencias bajas
fftsrc([1:1:ii L:-1:(L-ii+1)],:) = 0;
% rotar ejes
rfsrc = rotate(real(ifft(fftsrc)));
rfsrc = interp1(linspace(1,n,L),rfsrc,1:n);
rfsrc(:,1) = src(:,1);
% frecuencia de corte que produce esa minima señal en el eje
end

