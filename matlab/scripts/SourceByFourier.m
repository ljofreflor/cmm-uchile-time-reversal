

% observaciones
% 1.- Generalmente existen dos picos, eso quiere decir que en ese punto no
% se encuentra la fuente dado que debería unirse la onda p con la s y se
% devería visualizar un solo impulso.

% para el evento p en el sensor q
p = 1;
for q  = mu.validAllList
    
    sensor = mu(p).gss(q);
    phyParam = mu(p).physicParameters; % parametros fisicos
    srcParam = mu(p).sourceParameters; % parametros de la fuente
    eventTime = mu(p).fftEventTimeWindowsBoundary; % dominio temporal
    data = mu(p).fftDataField(q); % datos corregidos al tamaño necesario
    
    dt = mu(p).Syncdt;        % delta de tiempo para la sincronizacion del evento
    r = sensor.r0;            % posicion del sensor
    R = mu(p).LocR;           % posicion de la fuente
    spektrum = fft(data);     % espectro de los datos
    testdata = ifft(spektrum);
    
    alpha = phyParam(1);      % parametros fisicos
    beta = phyParam(2);
    rho = phyParam(3);
    
    gf11 = GreenFrec(1,1,alpha,beta,rho,r-R,f); % funcion de Green
    gf12 = GreenFrec(1,2,alpha,beta,rho,r-R,f);
    gf13 = GreenFrec(1,3,alpha,beta,rho,r-R,f);
    gf22 = GreenFrec(2,2,alpha,beta,rho,r-R,f);
    gf23 = GreenFrec(2,3,alpha,beta,rho,r-R,f);
    gf33 = GreenFrec(3,3,alpha,beta,rho,r-R,f);
    
    % determinante de la funcion de green
    det = -gf13.^2.*gf22 + ...
        2*gf12.* gf13.* gf23 - gf11.* gf23.^2 - ...
        gf12.^2.*gf33 + gf11.* gf22.* gf33;
    
    inv11 = (gf22.*gf33 - gf23.^2)./det; % inversa de la funcion de Green
    inv12 = -(gf12.*gf33 - gf23.*gf13)./det;
    inv13 = (gf12.*gf23 - gf13.*gf22)./det;
    inv22 = (gf11.*gf33 - gf13.^2)./det;
    inv23 = -(gf11.*gf23 - gf12.*gf13)./det;
    inv33 = (gf11.*gf22 - gf12.^2)./det;
    inv21 = inv12;
    inv31 = inv13;
    inv32 = inv23;
    
    XS = (inv11.*X + inv12.*Y + inv13.*Z); % espectro de la fuente
    YS = (inv21.*X + inv22.*Y + inv23.*Z);
    ZS = (inv31.*X + inv32.*Y + inv33.*Z);
    
    FS = [XS YS ZS]; % espectro de la fuente
    
    
    Q = real(ifft(FS));
    c = cov(FS);
    [v,e] = eig(c);
    
    plot(Q(:,2))
    
end

% definir el dominio temporal
% validar que la transformada de fourier esté bien planteada
% hacer la combinación lineal que produzca el minimo error
% hacer la estimación para todo el dominio.
% encontrar el punto en donde el error sea minimo
% hacer un análisis de componenetes principales en todo el dominio