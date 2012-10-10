function [src, cutsrc, filtsrc, filtcutsrc, error] = source(event, nSync, nSrc, dt)

% paramentros f`isicos del evento en especial
alpha = event.alpha;
beta  = event.beta;
rho   = event.rho;

LocR = event.LocR;
t0 = event.origin_time;
% para la recosntrucci`o de la fuente se requiere un dt que es el tiempo
% entre medicion y la cantidad de mediciones de la reconstrucci`on, con
% ello se puede recosntruir la fuente en una ventana srcTime

srcTime = t0 + (0:(nSrc-1))*dt;

% matrices en donde se construye el sistema lineal
U = [];
A = [];

% Tamanio arbitrario de sincronizacion de los datos, es necesario
% encontrar un criterio que diga cual es el taman~io de sincronizaci'on
% 'optimo
timeSync = linspace(t0, event.last_time, nSync);

% cosntrucci`on del sistema matricial para en sensor sin cortar las colas
% entre el tiempo de llegada de la onda s y p
for k = 1:event.count
    % sensor a iterar
    sens = event.gss(k);
    hsr = sens.hardware_sampling_rate;
    index = ceil(dt*hsr);
    timeSens = sens.timevector;
    
    % transformar el sensor a campo de desplazamiento
    if sens.IsSpeedometer
        despla = detrend(cumsum(sens.data))';
    elseif sens.IsAccelerometer
        despla = detrend(cumsum(detrend(cumsum(sens.data))))';
    else
        despla = sens.data';
    end
    
    
    % tiempo de sincronización
    despla = interp1( timeSens, despla', timeSync )';  % desplazamiento sincronizado
    despla(isnan(despla)) = 0;                         % rellenar con ceros
    
    R = sens.r0 - LocR;
    timeDomain = timeSync - t0;
    [G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(R(1),R(2),R(3),timeDomain,alpha,beta,rho);
    
    % no todos los sensores empiezan el el mismo momento, no se entonces
    % por que los hacer partir todos en cero
    F11 = cumsum(G11);
    F12 = cumsum(G12);
    F13 = cumsum(G13);
    F22 = cumsum(G22);
    F23 = cumsum(G23);
    F33 = cumsum(G33);
    
    B = [];
    
    FF11=zeros(size(F11));
    FF12=zeros(size(F11));
    FF13=zeros(size(F11));
    FF22=zeros(size(F11));
    FF23=zeros(size(F11));
    FF33=zeros(size(F11));
    
    for jj = 1:nSrc
        for ii = 1:size(F11,2)
            FF11(ii) = F11(max(ii-(jj-1)*index,1)) - F11(max(ii-jj*index,1));
            FF12(ii) = F12(max(ii-(jj-1)*index,1)) - F12(max(ii-jj*index,1));
            FF13(ii) = F13(max(ii-(jj-1)*index,1)) - F13(max(ii-jj*index,1));
            FF22(ii) = F22(max(ii-(jj-1)*index,1)) - F22(max(ii-jj*index,1));
            FF23(ii) = F23(max(ii-(jj-1)*index,1)) - F23(max(ii-jj*index,1));
            FF33(ii) = F33(max(ii-(jj-1)*index,1)) - F33(max(ii-jj*index,1));
        end
        
        % agregar solo las dimensiones que tienen mediciones
        C = [];
        if sens.medicionesValidas(1) == 1
            C = [C  [FF11; FF12; FF13]];
        end
        if sens.medicionesValidas(2) == 1
            C = [C  [FF12; FF22; FF23]];
        end
        if sens.medicionesValidas(3) == 1
            C = [C [FF13; FF23; FF33]];
        end
        
        % agregar esas medicines a la matriz
        B = vertcat(B,C);
    end
    
    A = horzcat(A,B);
    
    if sens.medicionesValidas(1) == 1
        U = horzcat(U,despla(1,:));
    end
    if sens.medicionesValidas(2) == 1
        U = horzcat(U,despla(2,:));
    end
    if sens.medicionesValidas(3) == 1
        U = horzcat(U,despla(3,:));
    end
    
end

% esto aun no lo entiendo aun
magnitude=norm(A);
A=A/magnitude;
U=U/magnitude;

% inversa generalizada de Moore-Penrose para encontrar la fuente
alphas = (U*A')*pinv((A*A'));



src = zeros([size(alphas,2)/3 4]);
src(:,1) = srcTime';
src(:,2) = alphas(1:3:end)';
src(:,3) = alphas(2:3:end)';
src(:,4) = alphas(3:3:end)';


% repetir el procedimiento, pero con los sensores cortados
cutEvent = windowsErase(event);

for k = 1:cutEvent.count
    % sensor a iterar
    sens = cutEvent.gss(k);
    hsr = sens.hardware_sampling_rate;
    index = ceil(dt*hsr);
    timeSens = sens.timevector;
    
    
    % transformar el sensor a campo de desplazamiento
    if sens.IsSpeedometer
        despla = detrend(cumsum(sens.data))';
    elseif sens.IsAccelerometer
        despla = detrend(cumsum(detrend(cumsum(sens.data))))';
    else
        despla = sens.data';
    end
    
    %despla = testDataFunction(mu(ev),k,time2-t0)';
    % tiempo de sincronización
    despla = interp1( timeSens, despla', timeSync )';  % desplazamiento sincronizado
    despla(isnan(despla)) = 0;                         % rellenar con ceros
    
    R = sens.r0 - cutEvent.LocR;
    timeDomain = timeSync - cutEvent.origin_time;
    [G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(R(1),R(2),R(3),timeDomain,alpha,beta,rho);
    
    % no todos los sensores empiezan el el mismo momento, no se entonces
    % por que los hacer partir todos en cero
    F11 = cumsum(G11);
    F12 = cumsum(G12);
    F13 = cumsum(G13);
    F22 = cumsum(G22);
    F23 = cumsum(G23);
    F33 = cumsum(G33);
    
    B = [];
    
    FF11=zeros(size(F11));
    FF12=zeros(size(F11));
    FF13=zeros(size(F11));
    FF22=zeros(size(F11));
    FF23=zeros(size(F11));
    FF33=zeros(size(F11));
    
    for jj = 1:nSrc
        for ii = 1:size(F11,2)
            FF11(ii) = F11(max(ii-(jj-1)*index,1)) - F11(max(ii-jj*index,1));
            FF12(ii) = F12(max(ii-(jj-1)*index,1)) - F12(max(ii-jj*index,1));
            FF13(ii) = F13(max(ii-(jj-1)*index,1)) - F13(max(ii-jj*index,1));
            FF22(ii) = F22(max(ii-(jj-1)*index,1)) - F22(max(ii-jj*index,1));
            FF23(ii) = F23(max(ii-(jj-1)*index,1)) - F23(max(ii-jj*index,1));
            FF33(ii) = F33(max(ii-(jj-1)*index,1)) - F33(max(ii-jj*index,1));
        end
        
        % agregar solo las dimensiones que tienen mediciones
        C = [];
        if sens.medicionesValidas(1) == 1
            C = [C  [FF11; FF12; FF13]];
        end
        if sens.medicionesValidas(2) == 1
            C = [C  [FF12; FF22; FF23]];
        end
        if sens.medicionesValidas(3) == 1
            C = [C [FF13; FF23; FF33]];
        end
        
        % agregar esas medicines a la matriz
        B = vertcat(B,C);
    end
    
    A = horzcat(A,B);
    
    if sens.medicionesValidas(1) == 1
        U = horzcat(U,despla(1,:));
    end
    if sens.medicionesValidas(2) == 1
        U = horzcat(U,despla(2,:));
    end
    if sens.medicionesValidas(3) == 1
        U = horzcat(U,despla(3,:));
    end
    
end

% esto aun no lo entiendo aun
magnitude=norm(A);
A=A/magnitude;
U=U/magnitude;

% inversa generalizada de Moore-Penrose para encontrar la fuente
alphas = (U*A')*pinv((A*A'));


% luego de tener la fuente se puede comparar los sensores estimados contra
% los reales y ver el error de estimacion.

% se valida la forma de la fuente por medio del campo de desplazamiento con
% el campo de velocidades, esto quiere decir que ambas deben ser la misma.

cutsrc = zeros([size(alphas,2)/3 4]);
cutsrc(:,1) = srcTime';
cutsrc(:,2) = alphas(1:3:end)';
cutsrc(:,3) = alphas(2:3:end)';
cutsrc(:,4) = alphas(3:3:end)';


% filtrar las fuentes en sus dos versiones
filtsrc = filterLowPassSersor(src);
filtcutsrc = filterLowPassSersor(cutsrc);


% error del modelo
error = 0;
end
