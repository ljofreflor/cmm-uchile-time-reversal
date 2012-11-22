
function plotRevSignal(X,Y,Z)
R = sqrt(X.^2+Y.^2+Z.^2);

MAX = max(max(max((R(:,:,2,:)))))/3;
for ii = 1:size(R,4)
    fprintf('%d\n',ii);
    z = (R(:,:,5,ii));    
    imagesc(z);
    caxis([0 MAX]);
    colorbar;
    print('-painters', '-dpng','-r600', ['tr3',num2str(ii),'.png']);
end
end

