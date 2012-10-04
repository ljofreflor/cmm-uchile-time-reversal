n = size(source,1);
nn = 2^(nextpow2(n));
aa = zeros(3,nn);
a = zeros(3,n);
aa = source(:,2:4)';
% aa(1,1:n)=alphas(1:3:end);
% aa(2,1:n)=alphas(2:3:end);
% aa(3,1:n)=alphas(3:3:end);

for j = 1:10
    
cutfrec = 13 + j; %esto hay que hacerlo mejor

filter = ones(1,nn);

filter(1:cutfrec) = (linspace(1,cutfrec-1,cutfrec)-1)/cutfrec;

for i=1:3
    aux = fft(aa(i,:));
    aux(1:cutfrec)=0;
    aux(end:-1:end-cutfrec+1)=0;
    auxx = real(ifft(aux));
    a(i,:) = a(i,:)+auxx(1:n);
end
end
for i = 1:3
    subplot(1,3,i);
    plot(source(:,1), a(i,1:1:end));
    axis([min(source(:,1)) max(source(:,1)) min(min((a))) max(max(a))]);
end