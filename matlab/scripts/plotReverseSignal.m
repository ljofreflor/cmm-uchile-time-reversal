
modulo = 10000000000000*sqrt(X.^2+Y.^2+Z.^2);

MAXIMO = max(max(max((modulo(:,:,2,:)))))/3;
for i = 1:length(mu(1).t_axis)
    fprintf('%d\n',i);
    z = (modulo(:,:,6,i));    
    imagesc(z);
    caxis([0 MAXIMO]);
    %pcolor(z);
    %view(90,90);
    colorbar;
    pause;
end

