function  PlotInverseSignal( obj )
%PLOTINVERSESIGNAL Summary of this function goes here
%   Detailed explanation goes here

for i = 1:max(obj.sensor.T)
    plot(obj.U(:,:,3,i));
end
end

