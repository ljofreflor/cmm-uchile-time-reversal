function [v1,v2,v3] = EventCoeficients(src)
%  desplazamiento de la fuente
Z = src(:,2:4);

% norma en cada eje
n1 = norm(Z(:,1),2);
n2 = norm(Z(:,2),2);
n3 = norm(Z(:,3),2);

% cantidad de senañ en cada eje
v1 = n1/(n1+n2+n3);
v2 = n2/(n1+n2+n3);
v3 = n3/(n1+n2+n3);

end