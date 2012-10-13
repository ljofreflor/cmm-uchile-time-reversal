function source = filterLowPassSersor(source)
n = size(source,1);
nn = 2^(nextpow2(n));
aa = zeros(3,nn);
a = zeros(3,n);
aa(:,1:n) = source(:,2:4)';

for j = 1
    cutfrec = 13 + j; %esto hay que hacerlo mejor
    filter = ones(1, nn);
    filter(1:cutfrec) = (linspace(1,cutfrec-1,cutfrec) - 1)/cutfrec;
    filter(end:-1:end-cutfrec+1) = filter(1:cutfrec);
    for i=1:3
        aux = fft(aa(i,:)).*filter;
%        aux(1:cutfrec)=0;
%        aux(end:-1:end-cutfrec+1) = 0;
        auxx = real(ifft(aux));
        a(i,:) = a(i,:)+auxx(1:n);
    end
end
% reemplazar la fuente por la fuente filtrada
source(:,2:4) = a';
end