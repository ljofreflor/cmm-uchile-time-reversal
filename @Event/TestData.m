function data = TestData(LocR, origin_time, r0, t_time, p_time, s_time, alpha, beta, rho, n)
%ADD_TEST_GEOSENSOR Summary of this function goes here
%   Detailed explanation goes here
    % pulso con direccion aleatoria
    i = 1;
    j = 1;
    k = 1;

    % para poder visualizar la llegada de la onda s y la onda p se abarca
    % toda esa ventana de tiempo
    
    % El tiempo de unicio del buffer se encuentra entre el evento y la
    % llegada de la onda p
    a = t_time; 
    
    % el tienpo de finalización es el tiempo de llegada de la onda s mas
    % una ventada de la diferencia de tiempo entre la s y la p
    b = 2*s_time - p_time;
    
    % vector aleatorio ordenado para emular el hecho de que existe un
    % remuestreo variable
    r = r0 - LocR;
    s = sqrt( r(1)^2 + r(2)^2 + r(3)^2 );
    % remuestreo adquiere el tamanio adecuado 
    T = linspace(a, b, n);
    n = length(T);    
    [G11,G12,G13,G22,G23,G33] = Event.scalarGreenKernel(r(1),r(2),r(3),T - origin_time ,alpha,beta,rho);
    % se considera la fuente un impulso unitario en direccion del eje z
    data = zeros(n,3);
    data(:,1) = G11*i+G12*j+G13*k;
    data(:,2) = G12*i+G22*j+G23*k;
    data(:,3) = G13*i+G23*j+G33*k; 
    % la simetría se conserva para todas las seniales recibidas en cada uno
    % de los sensores.
end

