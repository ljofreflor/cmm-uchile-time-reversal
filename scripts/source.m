function src = source(mu, ev,testFlag, desplaFlag, cutFlag, Nsync, nSrc, dt)

% testFlag que determina si es un test o un ejemplo real
% desplaFlag que determina si es una reconstruccion mediante el campo de
% desplazamiento o el campo de velocidades.
% cutFlag que determina si la reconstruccion es mediante las sen~ales ser'an
% cortadas en un intervalo entre la onda p y la s.
% ev numero del evento con el cual se quiere reconstruir
% en total, que son los que est'an cargados en memoria.

if cutFlag == 0;
    event = mu(ev);
else
    mu = windowerase(mu,ev);
    event = mu(ev);
end

% paramentros f`isicos del evento en especial
alpha = event.alpha;
beta  = event.beta;
rho   = event.rho;

% para la recosntrucci`o de la fuente se requiere un dt que es el tiempo
% entre medicion y la cantidad de mediciones de la reconstrucci`on, con
% ello se puede recosntruir la fuente en una ventana srcTime

srcTime = event.origin_time + (0:(nSrc-1))*dt;
% matrices en donde se construye el sistema lineal
U = [];
A = [];

% Tamanio arbitrario de sincronizacion de los datos, es necesario
% encontrar un criterio que diga cual es el taman~io de sincronizaci'on
% 'optimo
N = Nsync;
timeSync = linspace(event.origin_time,event.last_time,N);

% cosntrucci`on del sistema matricial
for k = 1:event.count    
    % sensor a iterar
    sens = event.gss(k);
    hsr = sens.hardware_sampling_rate;
    index = ceil(dt*hsr);
    timeSens = sens.timevector;
    
    if desplaFlag == 1 && testFlag == 0
        despla = detrend(cumsum(sens.data))';
    else
        despla = sens.data';
    end
    %despla = testDataFunction(mu(ev),k,time2-t0)';
    % tiempo de sincronización
    despla = interp1( timeSens, despla', timeSync )';  % desplazamiento sincronizado
    despla(isnan(despla)) = 0;                         % rellenar con ceros
    
    R = sens.r0 - mu(ev).LocR;
    timeDomain = timeSync - event.origin_time;
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
alphas = (U*A')*pinv((A*A'));

clear('A');clear('B');clear('U');

% luego de tener la fuente se puede comparar los sensores estimados contra
% los reales y ver el error de estimacion
if desplaFlag == 1
    
    h = figure;
    
    subplot(1,3,1);
    plot(srcTime, alphas(1:3:end));
    axis([min(srcTime) max(srcTime) min(alphas) max(alphas)]);
    
    subplot(1,3,2);
    plot(srcTime, alphas(2:3:end));
    axis([min(srcTime) max(srcTime) min(alphas) max(alphas)]);
    
    subplot(1,3,3);
    plot(srcTime, alphas(3:3:end));
    axis([min(srcTime) max(srcTime) min(alphas) max(alphas)]);
    
    
    % se almacena la las mediciones de la fuente con la ventana de tiempo
    % respectiva
    source = zeros([size(alphas,2)/3 4]);
    source(:,1) = srcTime';
    source(:,2) = alphas(1:3:end)';
    source(:,3) = alphas(2:3:end)';
    source(:,4) = alphas(3:3:end)';
    
    % guardar los datos obtenidos en archivos para poder ser usados en
    % informes.
    fileName =  strcat(['test' num2str(testFlag) 'cut' num2str(cutFlag) ...
        'desplaFlag' num2str(desplaFlag) 'nsrc' num2str(nSrc) 'nsync' num2str(Nsync) 'dt' num2str(dt) ]);
    cd sourceEstimation/;
        save(strcat([fileName '.mat']),'source');
        print(h,'-dpng',strcat([fileName '.png'] ));
    cd ..;    
    close(h);
else
    subplot(1,3,1);
    plot(srcTime, cumsum(alphas(1:3:end)));
    subplot(1,3,2);
    plot(srcTime, cumsum(alphas(2:3:end)));
    subplot(1,3,3);
    plot(srcTime, cumsum(alphas(3:3:end)));
end
end
