function plotSensor(event, index)
gs = event.gss(index);

subplot(1,3,1);
plot(gs.timevector, gs.data(:,1))
axis([min(gs.timevector) max(gs.timevector) min(gs.data(:)) max(gs.data(:))]);

subplot(1,3,2);
plot(gs.timevector, gs.data(:,2))
axis([min(gs.timevector) max(gs.timevector) min(gs.data(:)) max(gs.data(:))]);

subplot(1,3,3);
plot(gs.timevector, gs.data(:,3))
axis([min(gs.timevector) max(gs.timevector) min(gs.data(:)) max(gs.data(:))]);
end