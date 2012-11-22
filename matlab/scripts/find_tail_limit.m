function [index, time] = find_tail_limit(gss, per)
% Findtaillimit(signal,tolerance,p) given a signal, a
% tolerance and a norm, finds when the tail is smaller
% than that tolerance and therefore negligible.

if gss.IsSpeedometer
    gss.data = detrend(cumsum(gss.data));
    gss.IsSpeedometer = 0;
elseif gss.IsAccelerometer
    gss.data = detrend(cumsum(detrend(cumsum(gss.data))));
    gss.IsAccelerometer = 0;
end

s = sum(cumsum(gss.data.^2),2);
s = s/max(s);
index = max(find(s <= per));
time = gss.timevector(index);
end

