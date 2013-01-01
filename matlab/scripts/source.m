function [src, filtsrc, error, U] = source(event, nSrc, L, por)

% gssIndex: indice de los sensores para reconstruir la fuente
% nSrc: numero de elementos de la fuente
% event: evento del cual se quiere reconstruir la fuente

% para la recosntrucci`o de la fuente se requiere un dt que es el tiempo
% entre medicion y la cantidad de mediciones de la reconstrucci`on, con
% ello se puede recosntruir la fuente en una ventana srcTime.

% la ventana srcTime esta centrada en el tiempo estimado en los set de
% datos.

event = windowsErase(event);
srcTime = event.origin_time + linspace(-por*L,(1-por)*L,nSrc);
dt = srcTime(2) - srcTime(1);

% srcTime = event.origin_time + ((0:(nSrc - 1)) - round(nSrc/4))*dt;
% srcTime = event.origin_time + (0:(nSrc - 1))*dt;

% podemos considerar la ventana de tiempo de la fuente de tal manera que
% sea la ventana de largo mínimo que capture la totalidad de la informacion
% de los sensores.


% matrices en donde se construye el sistema lineal, A*alpha = U en donde U
% son los geosensores y A es la convolucion de la fuente que es combinacion
% lineal de rectángulos con el Kernel de Green.
U = [];
A = [];

for kk = 1:event.count
    % transformar el sensor a campo de desplazamiento en funcion del flag
    % que informa el objeto
    if event.gss(kk).IsSpeedometer
        event.gss(kk).data = detrend(cumsum(event.gss(kk).data));
        event.gss(kk).IsSpeedometer = 0;
    elseif event.gss(kk).IsAccelerometer
        event.gss(kk).data = detrend(cumsum(detrend(cumsum(event.gss(kk).data))));
        event.gss(kk).IsAccelerometer = 0;
    end
    
    % concatenar como filas los resultados de los sensores
    if event.gss(kk).medicionesValidas(1) == 1
        U = horzcat(U,event.gss(kk).data(:,1)');
    end
    if event.gss(kk).medicionesValidas(2) == 1
        U = horzcat(U,event.gss(kk).data(:,2)');
    end
    if event.gss(kk).medicionesValidas(3) == 1
        U = horzcat(U,event.gss(kk).data(:,3)');
    end
end

for kk = 1:event.count
    
    % frecuencia de muestreo
    hsr = event.gss(kk).hardware_sampling_rate;
    
    % la relacion dt*hsr > 1
    deltat = dt*hsr;
    
    R = event.gss(kk).r0 - event.LocR;
    % timeDomain = event.gss(kk).timevector - event.origin_time;
    timeDomain = event.gss(kk).timevector - srcTime(1);
    
    [G11,G12,G13,G22,G23,G33] = scalarGreenKernel(R(1),R(2),R(3),timeDomain,event.alpha, event.beta, event.rho);

    % integraci'on de la funcion de Green
    dtdomain = timeDomain(2) - timeDomain(1);

    F11 = cumsum(G11)*dtdomain;
    F12 = cumsum(G12)*dtdomain;
    F13 = cumsum(G13)*dtdomain;
    F22 = cumsum(G22)*dtdomain;
    F23 = cumsum(G23)*dtdomain;
    F33 = cumsum(G33)*dtdomain;
    
    
    FF11=zeros(size(F11));
    FF12=zeros(size(F11));
    FF13=zeros(size(F11));
    FF22=zeros(size(F11));
    FF23=zeros(size(F11));
    FF33=zeros(size(F11));
    
    % matriz auxiliar en donde se almacenaran todas las convoluciones
    % producidas en un solo sensor.
    B = [];
    for jj = 1:nSrc % para todo elemento de la base
        for ii = 1:size(F11,2)
            
            % indices para los saltos en la convolucion entre la base y la
            % funcion de Green
            tf = max(ii - floor((jj - 1)*deltat), 1);
            ti = max(ii - floor(jj * deltat), 1);
            
            % convolucion con respecto la base seleccionada
            FF11(ii) = F11(tf) - F11(ti);
            FF12(ii) = F12(tf) - F12(ti);
            FF13(ii) = F13(tf) - F13(ti);
            FF22(ii) = F22(tf) - F22(ti);
            FF23(ii) = F23(tf) - F23(ti);
            FF33(ii) = F33(tf) - F33(ti);
            
        end
        
        % convolucion para un elemento de la base
        C = [];
        if event.gss(kk).medicionesValidas(1) == 1
            % almacenar la convolucion por las componentes
            C = [C  [FF11; FF12; FF13]];
        end
        if event.gss(kk).medicionesValidas(2) == 1
            C = [C  [FF12; FF22; FF23]];
        end
        if event.gss(kk).medicionesValidas(3) == 1
            C = [C [FF13; FF23; FF33]];
        end
        
        % agregar esas medicines a la matriz concatenandola verticalmente
        B = vertcat(B,C);
    end
    
    % convolucion de todos los sensores sobre todos los elementos de la
    % base seleccionada.
    
    A = horzcat(A,B);
    
end

% vector logico con los indices de las componentes de los sensores
indices = zeros(length(event.gss), 3 ,length(U));

for kk = 1:event.count
    if event.gss(kk).medicionesValidas(1) == 1
        ini =  findstr(U, event.gss(kk).data(:,1)');
        indices(kk, 1, ini:(ini + event.gss(kk).L - 1)) = 1;
    end
    if event.gss(kk).medicionesValidas(2) == 1
        ini =  findstr(U, event.gss(kk).data(:,2)');
        indices(kk, 2, ini:(ini + event.gss(kk).L - 1)) = 1;
    end
    if event.gss(kk).medicionesValidas(3) == 1
        ini =  findstr(U, event.gss(kk).data(:,3)');
        indices(kk, 3, ini:(ini + event.gss(kk).L - 1)) = 1;
    end
end


% resolucion del sistema
if cond(A*A') == Inf
    alphas = (U*A')*pinv(A*A');
else
    alphas = (U*A')/(A*A');
end

% fuente estimada
src = zeros([size(alphas,2)/3 4]);
src(:,1) = srcTime';
src(:,2) = alphas(1:3:end)';
src(:,3) = alphas(2:3:end)';
src(:,4) = alphas(3:3:end)';

% fuente filtrada
filtsrc = zeros(size(src));
filtsrc(:,1) = src(:,1);
filtsrc(:,2:4) = detrend(filterLowPassSersor(src(:,2:4)));

% promedio del error de medición
error = norm(alphas*A - U, 2);

end


