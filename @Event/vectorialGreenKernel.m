function [G11,G12,G13,G22,G23,G33] = vectorialGreenKernel(~, X, Y, Z, T,ds, alpha, beta, rho)
% Obtiene la función de Green $G_{i,j}$ con los desplazamientos espaciales
% $\widehat{r}$ y $t_0$ dados por el elemento model.gss(id)
%% distancia euclideana
R = sqrt(X.^2+Y.^2+Z.^2);
% indR0 = (R == 0);           % to avoid dividing by 0 we find where R==0 and
% R(indR0) = epsilon;

% factores que dependen de la resolución del dominio, por lo que las
% funciones delta de dirac deben ser comprendidas en un intervalo que es en
% función de la resolución

% aux_p = zeros(size(R));
% aux_s = zeros(size(R));
%
% for ii = 1:length(T);
%     aux_p(T(ii) <= t - R/alpha) = s(ii);
%     aux_s(T(ii) <= t - R/beta) = s(ii);
% end

P = (T >= R /alpha);

P1 = diff(P);
P1(end + 1,:,:,:) = 0;
% derivar todas las ordenaciones de cada una de las dimensiones
P2 = ipermute(diff(permute(P,[2 1 3 4])),[2 1 3 4]);
P2(:,end + 1,:,:) = 0;
P3 = ipermute(diff(permute(P,[3 2 1 4])),[3 2 1 4]);
P3(:,:,end + 1,:) = 0;
P4 = ipermute(diff(permute(P,[1 3 2 4])),[1 3 2 4]);
P4(end + 1,:,:,:) = 0;

P = abs(P1)|abs(P2)|abs(P3)|abs(P4);


S = (T <= R /beta);

S1 = diff(S);
S1(end + 1,:,:,:) = 0;
% derivar todas las ordenaciones de cada una de las dimensiones
S2 = ipermute(diff(permute(S,[2 1 3 4])),[2 1 3 4]);
S2(:,end + 1,:,:) = 0;
S3 = ipermute(diff(permute(S,[3 2 1 4])),[3 2 1 4]);
S3(:,:,end + 1,:) = 0;
S4 = ipermute(diff(permute(S,[1 3 2 4])),[1 3 2 4]);
S4(end + 1,:,:,:) = 0;

S = abs(S1)|abs(S2)|abs(S3)|abs(S4);


C = (R/alpha < T & T < R/beta);

C = and(not(P),C);
C = and(not(S),C);

P = abs(P) ./ (4 * pi * rho * alpha^2 * R.^3);

S = abs(S) ./ (4 * pi * rho * beta^2 * R);

C = T .*C ./ (4 * pi * rho * (R.^3));
% hasta hacerla correcta

% The equations for the Green's function is
G11 = (3*(X.^2)./(R.^2)-1).*C + (X.^2).*P/ds - ((X.^2)./(R.^2)-1).*S/ds;
G12 = (3*(X.*Y)./(R.^2)).*C   + (X.*Y).*P/ds - ((X.*Y)./(R.^2)).*S/ds;
G13 = (3*(X.*Z)./(R.^2)).*C   + (X.*Z).*P/ds - ((X.*Z)./(R.^2)).*S/ds;
G22 = (3*(Y.^2)./(R.^2)-1).*C + (Y.^2).*P/ds - ((Y.^2)./(R.^2)-1).*S/ds;
G23 = (3*(Y.*Z)./(R.^2)).*C   + (Y.*Z).*P/ds - ((Y.*Z)./(R.^2)).*S/ds;
G33 = (3*(Z.^2)./(R.^2)-1).*C + (Z.^2).*P/ds - ((Z.^2)./(R.^2)-1).*S/ds;
end

