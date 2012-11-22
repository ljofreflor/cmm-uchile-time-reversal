% prueba de time reversal luego de multiplicar cada una de las mediciones
% por la distancia al cuadrado como factor de corrección.

tr = Ev(1);

for ii = 1:tr.count
    tr.gss(ii).r_x = tr.gss(ii).r_x*norm(tr.LocR - tr.gss(ii).r0,2)^2;  
    tr.gss(ii).r_y = tr.gss(ii).r_y*norm(tr.LocR - tr.gss(ii).r0,2)^2;
    tr.gss(ii).r_z = tr.gss(ii).r_z*norm(tr.LocR - tr.gss(ii).r0,2)^2;
end

[X1,Y1,Z1] = tr.reverse_signal;
plotRevSignal(X1,Y1,Z1, 'tr1.avi');