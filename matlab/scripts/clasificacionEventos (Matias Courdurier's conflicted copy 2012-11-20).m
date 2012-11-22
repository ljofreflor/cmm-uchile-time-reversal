% clasificacion de eventos
vr1 = [Ev.vr1]';
vr2 = [Ev.vr2]';
vr3 = [Ev.vr3]';
data = [vr1 zeros(size(vr1))];
IDX = kmeans(data,3);

% GRAFICO
plot(data(IDX ==1,1),data(IDX ==1,2),'r.')
hold on
plot(data(IDX ==2,1),data(IDX ==2,2),'b.')
plot(data(IDX ==3,1),data(IDX ==3,2),'k.')
hold off