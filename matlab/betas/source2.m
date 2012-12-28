function [src, error] = source2(event, nSrc, L, por)

% gssIndex: indice de los sensores para reconstruir la fuente
% nSrc: numero de elementos de la fuente
% event: evento del cual se quiere reconstruir la fuente

% para la recosntrucci`o de la fuente se requiere un dt que es el tiempo
% entre medicion y la cantidad de mediciones de la reconstrucci`on, con
% ello se puede recosntruir la fuente en una ventana srcTime.

% la ventana srcTime esta centrada en el tiempo estimado en los set de
% datos.

srcTime = event.origin_time + linspace(-por*L,(1-por)*L,nSrc);
dt = srcTime(2) - srcTime(1);
alpha = event.alpha;
beta = event.beta;
rho = event.rho;

% srcTime = event.origin_time + ((0:(nSrc - 1)) - round(nSrc/4))*dt;
% srcTime = event.origin_time + (0:(nSrc - 1))*dt;

% podemos considerar la ventana de tiempo de la fuente de tal manera que
% sea la ventana de largo mínimo que capture la totalidad de la informacion
% de los sensores.


% matrices en donde se construye el sistema lineal, A*alpha = U en donde U
% son los geosensores y A es la convolucion de la fuente que es combinacion
% lineal de rectángulos con el Kernel de Green.
gss = [event.gss];
U = [gss.data(:)];
A = [];

for kk = 1:event.count    
    hsr = event.gss(kk).hardware_sampling_rate;
    deltat = dt*hsr;    
    R = event.gss(kk).r0 - event.LocR;
    tD = event.gss(kk).timevector - srcTime(1);    
    [G11,G12,G13,G22,G23,G33] = scalarGreenKernel(R(1),R(2),R(3),tD, alpha, beta, rho);
    G = [G11',G12',G13',G22',G23',G33'];
    dtdomain = tD(2) - tD(1);
    F = cumtrapz(G)*dtdomain;   
    B = [];
    [jj, ii] = meshgrid(1:nSrc, 1:size(F(:,1),1));   
    FF = F(max(ii - floor((jj - 1) * deltat), 1)) - F(max(ii - floor(jj * deltat), 1));
    % construccion de la matriz C 
end

% resolucion del sistema
alphas = U*A'\(A*A');

% fuente estimada
src = zeros([size(alphas,2)/3 4]);
src(:,1) = srcTime';
src(:,2) = alphas(1:3:end)';
src(:,3) = alphas(2:3:end)';
src(:,4) = alphas(3:3:end)';

% promedio del error de medición
error = norm(alphas*A - U, 2);

end


