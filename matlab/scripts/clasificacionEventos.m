% clasificacion de eventos
Ev = importEvents();
for ii = 1:length(Ev)
    % eliminar sensor_id = 25
    Ev(ii).gss([Ev(ii).gss.sensor_id] == 25) = [];
    Ev(ii).count = length( Ev(ii).gss);
    [Ev(ii).src, Ev(ii).filtsrc, Ev(ii).error, ~, Ev(ii).U, ~, ~]= source(Ev(ii), 100, 0.5,0.09);
    [Ev(ii).v1, Ev(ii).v2, Ev(ii).v3] = EventCoeficients(Ev(ii).src);
    [Ev(ii).vr1, Ev(ii).vr2, Ev(ii).vr3] = EventCoeficients(rotate(Ev(ii).filtsrc));
end

vr1 = [Ev.vr1]';
vr2 = [Ev.vr2]';
vr3 = [Ev.vr3]';
data = [vr1 zeros(size(vr1))];
IDX = kmeans(data,2);

% GRAFICO
plot(data(IDX ==1,1),data(IDX ==1,2),'r.')
hold on
plot(data(IDX ==2,1),data(IDX ==2,2),'b.')
hold off