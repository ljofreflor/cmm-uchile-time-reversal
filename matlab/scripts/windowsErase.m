function mu =  windowsErase(mu)
%En este script conservamos solamente la sen~al de los geosensores
%que se encuentra en una ventana ligeramente mas ancha que la ventana
%correspondiente al intervalo ideal de la onda P y la onda S.

for kk = 1:mu.count
    
    sens = mu.gss(kk);
    
    p_time = sens.p_time;
    s_time = sens.s_time;
    t_time = sens.t_time;
    
    n = size(sens.data,1);
    
    TriggerPosition = sens.TriggerPosition;
    Fs = mu.gss(kk).hardware_sampling_rate;
    
    delta_ps = s_time - p_time;
    
    lowerIndex = min(n, max( 1 , TriggerPosition + ...
        round(Fs*( p_time - .1*delta_ps - t_time))));
    
    uperIndex = max( 1, min( n , TriggerPosition + ...
        round(Fs*( s_time + .1*delta_ps - t_time))));
    
    % anular las mediciones de los sensores en los cuales la diferencia del
    % tiempo de llegada de la p y de la s no es válido, el sistema mediante
    % la inversa generalizada tratar'a esos datos en el sistema matricial
    % obteniendo siempre soluci`on.
    
    if mu.gss(kk).diferenciaPSvalida
        mu.gss(kk).data(1:lowerIndex,:) = 0;
        mu.gss(kk).data(uperIndex:n,:) = 0;
    else
        mu.gss(kk).data(:,:) = 0;
        mu.gss(kk).data(:,:) = 0;
    end
end
end
