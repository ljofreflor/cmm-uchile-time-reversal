classdef Event 
    %MODEL Clase que abstrae un evento s`ismico. Esta clase contiene un conjunto de par`ametros
    % correspondiente al evento en si, como el tiempo estimado por codelco y la posici'on en los
    % set de datos dados en los documentos
    properties
        eventName
        beta_est
        alpha_est
        alpha_ind
        beta_ind          % estimaciones individuales
        gss;              % lista de geosensores
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
        % estimaciones de alpha, beta y origin_time para cada sensor por
        % separado verificar la consistencia de los datos.
        all_est
        % lista de las velocidades alpha y beta
        alpha_ind_post
        beta_ind_post
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


