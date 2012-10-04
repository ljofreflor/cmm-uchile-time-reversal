event = mu(1);
alpha = event.alpha;
beta = event.beta;
rho = event.rho;
dt = 0.00005;
L = 100;
srcTime = (0:(L-1))*dt;

U = [];
A = [];

t0 = event.origin_time;
tf = event.last_time;

% todos los sensores con sus respectivas mediciones
sensors = find( event.validSP_list == 1 );

% sincn : tamanio de sincronizacion
% sens  : sensor de la iteracion
% hsr   : frecuecia de muestreo

for k = 1:13
    sincn = 20000;
    sens = event.gss(k);
    hsr = sens.hardware_sampling_rate;
    index = ceil(dt*hsr);
    time = sens.T(1) + (0:(size(sens.data,1)-1))/hsr;
    sinctime = linspace(t0,tf,sincn);
    r0 = event.LocR;
    %despla = detrend(cumsum(sens.data));
    despla = datosArticiales(sens, t0, r0, alpha, beta, rho, sincn)';
    R = sens.r0 - r0;
    x = R(1);
    y = R(2);
    z = R(3);
    timeDomain = sinctime-t0;
    [G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(x,y,z,timeDomain,alpha,beta,rho);
    F11 = cumsum(G11);
    F12 = cumsum(G12);
    F13 = cumsum(G13);
    F22 = cumsum(G22);
    F23 = cumsum(G23);
    F33 = cumsum(G33);  
    
    
    FF11=zeros(size(F11));
    FF12=zeros(size(F11));
    FF13=zeros(size(F11));
    FF22=zeros(size(F11));
    FF23=zeros(size(F11));
    FF33=zeros(size(F11));
    
    B = [];
    for jj = 1:L
        for ii = 1:size(F11,2)
            FF11(ii) = F11(max(ii-(jj-1)*index,1)) - F11(max(ii-jj*index,1));
            FF12(ii) = F12(max(ii-(jj-1)*index,1)) - F12(max(ii-jj*index,1));
            FF13(ii) = F13(max(ii-(jj-1)*index,1)) - F13(max(ii-jj*index,1));
            FF22(ii) = F22(max(ii-(jj-1)*index,1)) - F22(max(ii-jj*index,1));
            FF23(ii) = F23(max(ii-(jj-1)*index,1)) - F23(max(ii-jj*index,1));
            FF33(ii) = F33(max(ii-(jj-1)*index,1)) - F33(max(ii-jj*index,1));
        end
        C=[FF11 FF12 FF13; FF12 FF22 FF23; FF13 FF23 FF33];
        B = vertcat(B,C);
    end
    size(B);
    A = horzcat(A,B);
    U = horzcat(U,despla(1,:),despla(2,:),despla(3,:));
    size(A);
end

alphas = (U*A')*pinv((A*A'));
%clear('A'); clear('B'); clear('U');
subplot(3,1,1);
plot(srcTime, alphas(1:3:end));
subplot(3,1,2);
plot(srcTime, alphas(2:3:end));
subplot(3,1,3);
plot(srcTime, alphas(3:3:end));
