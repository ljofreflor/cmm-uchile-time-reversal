function [src, filtsrc, error, alphas] = source(event, nSrc, dt, gssIndex)

% gssIndex: indice de los sensores para reconstruir la fuente

% paramentros f`isicos del evento en especial
alpha = event.alpha;
beta  = event.beta;
rho   = event.rho;
LocR = event.LocR;
gss = [event.gss];
minTIMES = [gss.firsttime];
t0 = event.origin_time;

% para la recosntrucci`o de la fuente se requiere un dt que es el tiempo
% entre medicion y la cantidad de mediciones de la reconstrucci`on, con
% ello se puede recosntruir la fuente en una ventana srcTime

srcTime = t0 + (0:(nSrc - 1))*dt;

% matrices en donde se construye el sistema lineal
U = [];
A = [];

% cosntrucci`on del sistema matricial para en sensor sin cortar las colas
% entre el tiempo de llegada de la onda s y p
for k = gssIndex
    % sensor a iterar
    sens = event.gss(k);
    hsr = sens.hardware_sampling_rate;
    
    % la relacion dt*hsr > 1
    deltat = dt*hsr;
    
    % transformar el sensor a campo de desplazamiento
    if sens.IsSpeedometer
        despla = detrend(cumsum(sens.data))';
    elseif sens.IsAccelerometer
        despla = detrend(cumsum(detrend(cumsum(sens.data))))';
    else
        despla = sens.data';
    end
    
    R = sens.r0 - LocR;
    timeDomain = sens.timevector - t0;
    dtdomain = (timeDomain(2) - timeDomain(1));
    [G11,G12,G13,G22,G23,G33] = scalarGreenKernel(R(1),R(2),R(3),timeDomain,alpha,beta,rho);
    
    % integraci'on de la funci'on de Green
    F11 = cumsum(G11)*dtdomain;
    F12 = cumsum(G12)*dtdomain;
    F13 = cumsum(G13)*dtdomain;
    F22 = cumsum(G22)*dtdomain;
    F23 = cumsum(G23)*dtdomain;
    F33 = cumsum(G33)*dtdomain;
    
    B = [];
    
    FF11=zeros(size(F11));
    FF12=zeros(size(F11));
    FF13=zeros(size(F11));
    FF22=zeros(size(F11));
    FF23=zeros(size(F11));
    FF33=zeros(size(F11));
    
    % para que integramos si luego derivaremos de nuevo? seria mas practico
    % utilizar la funcuon de green traslada e interpolada sobre los puntos
    % necesarios.
    
    for jj = 1:nSrc
        for ii = 1:size(F11,2)
            
            % indices
            tf = max(ii-floor((jj-1)*deltat),1);
            ti = max(ii-ceil(jj*deltat),1);
            
            
            FF11(ii) = F11(tf) - F11(ti);
            FF12(ii) = F12(tf) - F12(ti);
            FF13(ii) = F13(tf) - F13(ti);
            FF22(ii) = F22(tf) - F22(ti);
            FF23(ii) = F23(tf) - F23(ti);
            FF33(ii) = F33(tf) - F33(ti);
            
            % analisis de los indices
            indice1(jj,ii)   = max(ii-round((jj-1)*deltat));
            indice2(jj,ii)   = max(ii-round(jj*deltat));
            indiceDif(jj,ii) = max(ii-round((jj-1)*deltat)) - max(ii-round(jj*deltat));
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

% inversa generalizada de Moore-Penrose para encontrar la fuente
alphas = U*pinv(A);

% promedio del error de medición
error = mean(((A)'*(alphas)' - U').^2);

src = zeros([size(alphas,2)/3 4]);
src(:,1) = srcTime';
src(:,2) = alphas(1:3:end)';
src(:,3) = alphas(2:3:end)';
src(:,4) = alphas(3:3:end)';

filtsrc = zeros(size(src));
filtsrc(:,1) = src(:,1);

%filtsrc(:,2:4) = detrend(filterLowPassSersor(src(:,2:4)));

end


