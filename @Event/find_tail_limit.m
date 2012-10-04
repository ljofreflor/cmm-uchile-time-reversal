function [ tail ] = find_tail_limit(obj, signal,tolerance)
% Findtaillimit(signal,tolerance,p) given a signal, a
% tolerance and a norm, finds when the tail is smaller
% than that tolerance and therefore negligible.
l=length(signal);
tail=1;
for i=1:l
    if ((norm(signal(1:i),obj.p)/(norm(signal,obj.p)))<=1-tolerance)
        tail=i;
    else
        break
    end
end

