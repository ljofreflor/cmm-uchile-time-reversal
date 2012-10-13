function obj = convParameters(obj)

% reestimaci'on de la locaci'on de la fuente y el tiempo de origen en funci'on de de los tiempos
% de llegada de la onda p y la onda s estimadas en el set de datos entregadas por codelco.

options = optimset('Display','off','LargeScale','on');

iter = true;
while iter
    % todos los sensores que tengan validados las ondas s y p por separado
    gss = [obj.gss];
    validGss = logical([gss.validS] .* [gss.validP]);
    validGssIndex = find(validGss == 1);
    r0 = vertcat(gss.r0);
    r0 = r0(validGssIndex,:);
    p_times = [gss.p_time]';
    p_times = p_times(validGssIndex);
    s_times = [gss.s_time]';
    s_times = s_times(validGssIndex);
    t0 = obj.origin_time;
    alpha = obj.alpha;
    beta = obj.beta;
    
    % fuci`on objetivo: suma de los errores de estimaci`on de posici'on de la
    % fuente en funci'on de los tiempos de llegada de la onda s y p.
    sumOfErrorSourcePosByPtimeAndStime = @(r) sum(...
        ((r(1) - r0(:,1)).^2+(r(2) - r0(:,2)).^2+(r(3) - r0(:,3)).^2-...
        ((p_times-t0).*alpha).^2).^2+...
        ((r(1)-r0(:,1)).^2+(r(2)-r0(:,2)).^2+(r(3)-r0(:,3)).^2-...
        ((s_times-t0).*beta).^2).^2 ...
        );
    % se usa la estimaci'on actual de la fuente como estimaci`o inicial
    [obj.LocR, valueErr1, flagR] = fminunc(sumOfErrorSourcePosByPtimeAndStime,obj.LocR ,options);
    obj.LocR_est = [obj.LocR_est;  obj.LocR];
    
    sumOfErrorOriginTimeByPtimeAndStime = @(t) sum((t - (alpha*p_times - beta*s_times)./(alpha - beta)).^2);
    [obj.origin_time, valueErr2, flagT] = fminunc(sumOfErrorOriginTimeByPtimeAndStime ,obj.origin_time,options);
    obj.origin_time_est = [obj.origin_time_est obj.origin_time];
    
    iter = ~(flagR == 5 && flagT == 1);
end

end

