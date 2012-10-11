
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