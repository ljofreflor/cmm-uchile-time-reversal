classdef Event
    %MODEL Clase que abstrae un evento s`ismico. Esta clase contiene un conjunto de par`ametros
    % correspondiente al evento en si, como el tiempo estimado por codelco y la posici'on en los
    % set de datos dados en los documentos
    properties
        name
        beta_est
        alpha_est
        alpha_ind
        beta_ind          % estimaciones individuales
        gss;              % lista de geosensores
        alpha
        beta
        rho
        
        first_time                      % tiempo de la primera medicion
        last_time                       % tiempo de la ultima medicion
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
        
        % parametros de estimacion de la fuente
        src
        filtsrc
        e
        % porcentaje de senal en caja eje canonico
        v1
        v2
        v3
        
        % porcentaje de senal en cada eje rotado
        vr1
        vr2
        vr3
        
        % elementos de la resolucion del sistema para la estimacion de la
        % fuente
        A
        U
        indices
        alphas
        
        
    end
    
    methods
        % class constructor
        function obj =  Event(name,alpha, beta, rho, LocR, origin_time, error, tail_per)
            obj.name = name;
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
        
        obj       = addGeosensor(obj, gs, vel)
        [X,Y,Z]   = field(obj,i)
        obj       = set_domain(obj,nx,ny,nz,nt)
        obj       = set_domain_center(obj,n);
        obj = set_domain_unit(obj , nx , ny , nz , nt)
        obj = convParameters(obj);
    end
end


