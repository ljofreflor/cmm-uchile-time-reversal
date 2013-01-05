%% Guardar coeficientes
for ii = 1:length(Ev)
    % eliminar sensor_id = 25
    Ev(ii).gss([Ev(ii).gss.sensor_id] == 25) = [];
    [Ev(ii).src, Ev(ii).filtsrc, Ev(ii).error]= source(Ev(ii), 100, 0.5,0.09);
    [Ev(ii).vr1, Ev(ii).vr2, Ev(ii).vr3] = EventCoeficients(rotate(Ev(ii).filtsrc));
end
