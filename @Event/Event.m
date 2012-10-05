classdef Event < handle
    %MODEL Clase que abstrae un evento s`ismico. Esta clase contiene un conjunto de par`ametros
    % correspondiente al evento en si, como el tiempo estimado por codelco y la posici'on en los
    % set de datos dados en los documentos
    properties
        eventName
        sp_valid
        cordenadasValidad
        Syncdt
        fftEventTimeWindowsBoundary
        sourceParameters
        physicParameters
        maxDataSize
        beta_est
        alpha_est
        alpha_ind
        beta_ind          % estimaciones individuales
        gss;              % lista de geosensores
        p_times
        s_times;          % tiempo de llegada de la onda s y onda p
        alpha
        beta
        rho
        first_time
        last_time                       % tiempo de la primera y ultima medicion
        count;                          % cantidad de sensores en el modelo
        LocR, origin_time               % posicion y tiempo inicial
        tail_per, error
        xi,xf,yi,yf,zi,zf               %dimensiones del dominio
        dx,dy,dz,dt                     % diferenciales entre cada punto del domino
        nx, ny, nz, nt
        n_rsmpl                         % numero de resampleo
        max_norm                        % Maxima Norma
        x_axis
        y_axis
        z_axis
        t_axis            % dimensiones del dominio
        X_domain
        Y_domain
        Z_domain
        T_domain          % dimensiones 4 dimensionales
        origin_time_est;                % estimacion del tiempo inicial
        % estimacion de r_0 por medio de convergencia de parametros
        LocR_est
        r0                              % coeficiente x0 y0 z0 de cada sensor
        dis_to_src                      % listas de distancias de los sensores a la fuente estimada
        dis_to_src_old
        % estimaciones de alpha, beta y origin_time para cada sensor por
        % separado verificar la consistencia de los datos.
        all_est
        % lista de las velocidades alpha y beta
        alpha_ind_post
        beta_ind_post
        
        % lista que contiene los flag de aceptacion de P, S y SP
        validP_list
        validS_list
        validSP_list
        
        % parametros estadisticos
        mean_alpha
        std_alpha
        meanSP_alpha
        stdSP_alpha
        
        mean_beta
        std_beta
        meanSP_beta
        stdSP_beta
        
        validAllList
        
        % cociente entre la distancia inicial y la estimada
        disc_cocient
    end
    
    methods
        % class constructor
        function obj =  Event(alpha, beta, rho, LocR, origin_time, error, tail_per)
            obj.count           = 0;
            obj.alpha           = alpha;
            obj.beta            = beta;
            obj.alpha_est       = alpha;
            obj.beta_est        = beta;
            obj.rho             = rho;
            obj.LocR            = LocR;
            % posicion inicial estimada
            obj.LocR_est        = LocR;
            obj.origin_time     = origin_time;
            obj.origin_time_est = origin_time;
            obj.first_time      = origin_time;
            obj.last_time       = origin_time;
            obj.error           = error;
            % aun hay que encontrar el porcentage optimo para la cola
            obj.tail_per        = tail_per;
            % update the domain for each sensor
            obj.xi              = obj.LocR(1);
            obj.xf              = obj.LocR(1);
            obj.yi              = obj.LocR(2);
            obj.yf              = obj.LocR(2);
            obj.zi              = obj.LocR(3);
            obj.zf              = obj.LocR(3);
        end
        
        % setear valores, estas son reglas de integridad que harán que el
        % algoritmo sea mas segundo y mas manipulable.
        function AddGss(obj, gs_list)
            gs = gs_list(end);
            % tomamos el ultimo elemento
            if( isempty(gs))
                disp('no puede asignar un geosensor vacio');
            else
                %verificamos que cada uno de sus atributos esté asignado,
                %hay que implementar los mensajes.
                obj.p_times = [obj.p_times gs.p_time];
                obj.s_times = [obj.s_times gs.s_time];
                obj.sp_valid = [obj.sp_valid gs.diferenciaPSvalida];
                obj.r0 = [obj.r0; gs.r0];
                % distancia a la fuente desde el sensor
                gs.dis_to_src  = norm(gs.r0-obj.LocR);
                gs.dis_to_src_old  = norm(gs.r0-obj.LocR);
                
                % agregar la distancia a la lista
                obj.dis_to_src = [obj.dis_to_src gs.dis_to_src];
                obj.dis_to_src_old = [obj.dis_to_src_old gs.dis_to_src_old];
                
                % agregar a la lista los tamanios de resampleo
                obj.n_rsmpl    = [obj.n_rsmpl length(gs.timevector)];
                obj.max_norm   = [obj.max_norm max([max(abs(gs.r_x)) max(abs(gs.r_y)) max(abs(gs.r_z))])];
                obj.alpha_ind  = [obj.alpha_ind gs.dis_to_src/(gs.p_time - obj.origin_time) ];
                obj.beta_ind   = [obj.beta_ind  gs.dis_to_src/(gs.s_time - obj.origin_time) ];
                obj.gss        = [obj.gss gs];
                obj.validP_list = [obj.validP_list gs.validP];
                obj.validS_list = [obj.validS_list gs.validS];
                obj.validSP_list = [obj.validSP_list gs.validSP];
                
                % setear parametros estadisticos
                obj.mean_alpha = mean(obj.alpha_ind);
                obj.std_alpha = std(obj.alpha_ind);
                
                obj.mean_beta = mean(obj.beta_ind);
                obj.std_beta = std(obj.beta_ind);
                
                obj.count = obj.count + 1;
                
                
            end
        end
        
        e         = error_resample(obj, sensor, n)
        obj       = addGeosensor(obj, gs, vel)
        obj       = update(obj, error, p ,tail_per,update_type,is_cut)
        obj       = update_variable(obj, error,tail_per)
        per       = find_tail_limit( obj, signal,tolerance,p)
        [ X Y Z ] = test_max_domain(obj, n)
        obj       = convolution(id)
        [X,Y,Z]   = field(obj,i)
        [G11,G12,G13,G22,G23,G33] = green_kernel(obj,X,Y,Z,T,ds,alpha,beta,rho)
        obj       = set_domain(obj,nx,ny,nz,nt)
        obj       = find_max_norm(obj)
        inf       = data( obj, id, columna, fila)
        out       = SignalProcessing(obj, sensor, tail)
        n         = n_resample(obj, sensor, e);
        obj       = set_domain_center(obj,n);
        sensor    = uniform_random_signal(obj, m);
        % estimar paramtros en funcion de datos experimentales
        obj       = set_est_parameters(obj);
        % remuestreos
        %resampleo variable que iterativamente samplea en los máximos
        %hasta que el error total de interpolación es menor o igual a e
        %con el orden p
        [X Y Z T] = signal_variable_resample_2(obj,id,e)
        %resampleo constante hasta que el error total de interpolación
        %es menor o igual a e con el orden p
        [X,Y,Z,T] = signal_resample(obj, sensor, n)
        %puebas
        test_model = test(obj,i,j,k)
        obj = add_test_geosensor( obj, gs )
        obj = set_domain_unit(obj , nx , ny , nz , nt)
        [ X Y Z X_domain Y_domain Z_domain T_domain] = test_with_real_locations_adjusted(obj)
        setNewDomain(obj, x1,x2,nx,y1,y2,ny,z1,z2,nz,t1,t2,nt)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function maxDataSize = get.maxDataSize(obj)
            maxDataSize = length(obj.gss(1).data(:,1));
            for ii = 1:obj.count
                temp = length(obj.gss(ii).data(:,1));
                if temp > maxDataSize
                    maxDataSize = temp;
                end
            end
            obj.maxDataSize = maxDataSize;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function physicParameters = get.physicParameters(obj)
            physicParameters = [obj.alpha obj.beta obj.rho];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function sourceParam = get.sourceParameters(obj)
            sourceParam = [obj.LocR obj.origin_time];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function time = get.fftEventTimeWindowsBoundary(obj)
            time = [obj.origin_time obj.last_time];
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function data = fftDataField(obj, index)
            dat = obj.gss(index).data;
            mn = mean(dat);
            dat(:,1) = dat(:,1) - mn(1);
            dat(:,2) = dat(:,2) - mn(2);
            dat(:,3) = dat(:,3) - mn(3);
            
            % integrar las señales
            dat = cumsum(dat);
            % centrarla
            mn = mean(dat);
            dat(:,1) = dat(:,1) - mn(1);
            dat(:,2) = dat(:,2) - mn(2);
            dat(:,3) = dat(:,3) - mn(3);
            % cantidad de datos necesarios para la fft
            L = 2^nextpow2(obj.maxDataSize);
            % ventana de tiempo real con frecuencia de muestreo real
            gssTime = obj.gss(index).RealWindowsTime;
            eventTime = linspace(obj.origin_time, obj.last_time,L);
            dat = interp1(gssTime', dat, eventTime');
            
            
            dat(isnan(dat))=0;
            data = dat;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function dt = get.Syncdt(obj)
            L = 2^nextpow2(obj.maxDataSize);
            eventTime = linspace(obj.origin_time, obj.last_time,L);
            dt = eventTime(2) - eventTime(1);
        end
        obj = convParameters(obj);
    end
    
    
    methods (Static)
        [X,Y,Z] = random_test(m,n)
        [G11,G12,G13,G22,G23,G33] = scalarGreenKernel(x, y, z, T, alpha, beta, rho)
        [X,Y,Z,mu] = standar_test
        [X,Y,Z] = standat_test_adjusted
        [X,Y,Z] = standar_test_2
        [X,Y,Z] = test_asimetrico
        data = TestData(LocR, origin_time, r, t_time, p_time, s_time, alpha, beta, rho, n)
    end
end


