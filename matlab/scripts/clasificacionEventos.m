
for ii = 1:length(Ev)
    % eliminar sensor_id = 25
    Ev(ii).gss([Ev(ii).gss.sensor_id] == 25) = [];
    Ev(ii).count = length(Ev(ii).gss);
    [Ev(ii).src, Ev(ii).filtsrc, Ev(ii).error, Ev(ii).U]= source(Ev(ii), 100, 0.5,0.09);
    [Ev(ii).v1, Ev(ii).v2, Ev(ii).v3] = EventCoeficients(Ev(ii).src);
    [Ev(ii).vr1, Ev(ii).vr2, Ev(ii).vr3] = EventCoeficients(rotate(Ev(ii).filtsrc));
end

vr1 = [Ev.vr1]';
vr2 = [Ev.vr2]';
vr3 = [Ev.vr3]';
data = [[vr1 ] zeros(size(vr1))];
IDX = kmeans(data, 3);

% GRAFICO
plot(data(IDX ==1,1),data(IDX ==1,2),'r.')
hold on
plot(data(IDX ==2,1),data(IDX ==2,2),'b.')
plot(data(IDX ==3,1),data(IDX ==3,2),'g.')
hold off

% funcion de densidad
plot(sort(vr1),(1:length(vr1))/length(vr1))

% funcion de distribucion
quantil = sort(vr1);
prob = (1:length(vr1))/length(vr1);

% interpolacion
q = interp1(sort(vr2)',(1:length(vr2))/length(vr2),linspace(0,max(vr2),length(vr2)))
