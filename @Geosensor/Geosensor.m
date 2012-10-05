classdef Geosensor
    %SENSOR objeto que abstrae el concepto de sensor
    
    properties
        resampleErrorOnNorm
        resampleSize
        timeresamplevector
        timevector
        diferenciaPSvalida
        medicionesValidas
        %coordenadas
        r0
        %frecuencia de muestreo del sensor y peiordo
        hardware_sampling_rate
        resampling_rate
        period
        %unidad de tiempo en el que ocurre el evento
        TriggerPosition
        %norma máxima
        max_norm
        %mediciones
        r_x,r_y,r_z
        L
        data
        t_time
        p_time
        s_time;
        % serie de maximos de la senial invertida
        rvrse_amplt
        % si las ondas son aceptadas como tales
        validP;
        validS;
        validSP;
        IsAccelerometer
        IsSpeedometer
        sensor_id       
        %propiedades sobre las direcciones que hay mediciones
        validAll;        
    end
    
    methods
        %Constructor de la clase
        function obj = Geosensor(r0, t_time, hardware_sampling_rate, ...
                TriggerPosition,p_time,s_time,P_valid, S_valid, ...
                SP_valid, sensor_id)
            
            obj.r0 = r0;
            obj.hardware_sampling_rate = hardware_sampling_rate;
            obj.t_time = t_time;
            obj.TriggerPosition = TriggerPosition;
            obj.p_time = p_time;
            obj.s_time = s_time;
            obj.diferenciaPSvalida = (p_time < s_time);
            obj.validP = P_valid;
            obj.validS = S_valid;
            obj.validSP = SP_valid;
            obj.sensor_id = sensor_id;
            
            % por defecto un sensor es un velocìmetro 
            obj.IsSpeedometer = 1;
            obj.IsAccelerometer = 0;

            % existe un conjunto menor de sensores que son acelerometros
            accel = [76 82 118 126 146 147];

            id = obj.sensor_id;
            if id == 0
                % caso de prueba, nunca ocurrirà en la realidad que se mida campo de
                % desplazamiento, pero para hacer pruebas de los algoritmos es necesario
                obj.IsSpeedometer = 0;
                obj.IsAccelerometer = 0;
            elseif any(id == accel)
                % cuando se identifica un aceler'ometro
                obj.IsSpeedometer = 0;
                obj.IsAccelerometer = 1;
            end
        end
        tail = findTailLimit(obj, S, tail_per, p);
    end
end

