function FG = GreenFrec(ii,jj,alpha,beta,rho,R,f)
x = R(1);
y = R(2);
z = R(3);

r = norm(R,2);
gamma(1) = x./r;
gamma(2) = y./r;
gamma(3) = z./r;

% espectro de frecuencia para un ancho de banda dado.
frec = @(omega)(exp(+1i.*omega.*r./alpha))./(4.*pi.*rho.*alpha.^2.*r)...
    .*((gamma(ii).*gamma(jj)).*omega.^2 + (3.*gamma(ii).*gamma(jj)-Kdelta(ii,jj)).*(-(alpha)./(1i.*r)).*omega+(3.*gamma(ii).*gamma(jj)-Kdelta(ii,jj)).*(-(alpha)./(1i.*r)).^2)...
    +(exp(+1i.*omega.*r./beta ))./(4.*pi.*rho.*beta.^2.*r )...
    .*((gamma(ii).*gamma(jj)- Kdelta(ii,jj)).*omega.^2 + (3.*gamma(ii).*gamma(jj)-Kdelta(ii,jj)).*(-(beta)./(1i.*r)).*omega+(3.*gamma(ii).*gamma(jj)-Kdelta(ii,jj)).*(-beta./(1i.*r)).^2);

FG = frec(f);
end

