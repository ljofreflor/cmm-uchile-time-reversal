
s = 6;
T = mu(1).gss(s).T;
data = mu(1).gss(s).data;


V_x = data(:,1);
V_y = data(:,2);
V_z = data(:,3);

R_x = detrend(cumsum(data(:,1)));
R_y = detrend(cumsum(data(:,2)));
R_z = detrend(cumsum(data(:,3)));

n = length(R_x);

V_max = sqrt(V_x.^2 + V_y.^2 + V_z.^2);
R = sqrt(R_x.^2 + R_y.^2 + R_z.^2);
n_x = R_x./R;
n_y = R_y./R;
n_z = R_z./R;

plot(R);
th1 = zeros(1,n);
th2 = zeros(1,n);
th3 = zeros(1,n);


