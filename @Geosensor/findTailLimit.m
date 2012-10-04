function [ tail ] = find_tail_limit(~, signal,tolerance,p)
% Findtaillimit(signal,tolerance,p) given a signal, a
% tolerance and a norm, finds when the tail is smaller
% than that tolerance and therefore negligible.
l=length(signal);
tail=1;
for i=1:l
    if ((norm(signal(1:i),p) / (norm(signal,p))) <= 1 - tolerance)
        tail = i;
    else
        break
    end
end

