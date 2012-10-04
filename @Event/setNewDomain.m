function  setNewDomain(obj, x1,x2,nx,y1,y2,ny,z1,z2,nz,t1,t2,nt)
%SETNEWDOMAIN Summary of this function goes here
%   Detailed explanation goes here

obj.x_axis = linspace(x1,x2,nx);
obj.y_axis = linspace(y1,y2,ny);
obj.z_axis = linspace(z1,z2,nz);
obj.t_axis = linspace(t1,t2,nt);

obj.dx = obj.x_axis(2) - obj.x_axis(1);
obj.dy = obj.y_axis(2) - obj.y_axis(1);
obj.dz = obj.z_axis(2) - obj.z_axis(1);

obj.xi = x1;
obj.xf = x2;
obj.yi = y1;
obj.yf = y2;
obj.zi = z1;
obj.zf = z2;

end

