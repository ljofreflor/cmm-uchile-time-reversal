function plotSrc(src, origin_time)

Z = src(:,2:4);

n1 = norm(Z(:,1),2);
n2 = norm(Z(:,2),2);
n3 = norm(Z(:,3),2);

m = min(Z(:));
M = max(Z(:));

subplot(1,3,1);
plot(src(:,1),Z(:,1))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
hold on;
plot([ origin_time origin_time ],[m M],'Color','r','LineWidth',1);
hold off;
v1 = n1/(n1+n2+n3);
xlabel(v1);


subplot(1,3,2);
plot(src(:,1),Z(:,2))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
hold on;
plot([ origin_time origin_time ],[m M],'Color','r','LineWidth',1);
hold off;
v2 = n2/(n1+n2+n3);
xlabel(v2);


subplot(1,3,3);
plot(src(:,1),Z(:,3))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
hold on;
plot([ origin_time origin_time ],[m M],'Color','r','LineWidth',1);
hold off;
v3 = n3/(n1+n2+n3);
xlabel(v3);

end