s = source(:,2:4);

objfunc1 = @(u)(sum((u(1)*s(:,1)).^2 + (u(2)*s(:,2)).^2 + (u(3)*s(:,3)).^2));

xx = sum(s(:,2).^2);
yy = sum(s(:,3).^2);
zz = sum(s(:,4).^2);

xy = sum(s(:,2).*s(:,3));
xz = sum(s(:,2).*s(:,4));
yz = sum(s(:,3).*s(:,4));

% se requiere de un vector u