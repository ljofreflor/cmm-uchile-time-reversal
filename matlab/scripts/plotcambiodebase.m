
[rotatefiltsrc,N1,N2,N3] = rotate(filtsrc);

Z = rotatefiltsrc;
subplot(1,3,1);
plot(src(:,1),Z(:,1))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N1);

subplot(1,3,2);
plot(src(:,1),Z(:,2))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N2)

subplot(1,3,3);
plot(src(:,1),Z(:,3))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N3)

Z = src(:,2:4);

n1 = norm(Z(:,1),2);
n2 = norm(Z(:,2),2);
n3 = norm(Z(:,3),2);

N1 = n1/(n1+n2+n3);
N2 = n2/(n1+n2+n3);
N3 = n3/(n1+n2+n3);
subplot(1,3,1);
plot(src(:,1),Z(:,1))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N1);

subplot(1,3,2);
plot(src(:,1),Z(:,2))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N2)

subplot(1,3,3);
plot(src(:,1),Z(:,3))
axis([min(src(:,1)) max(src(:,1)) min(Z(:)) max(Z(:))]);
xlabel(N3)