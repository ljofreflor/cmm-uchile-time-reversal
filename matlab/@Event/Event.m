classdef Event
    % evento sismico
    
    properties (GetAccess = 'public', SetAccess = 'private')
        count;
        U;
        
    end
    
    properties
        % nombre del evento
        name;
        
        % parametros fisicos
        alpha;
        beta;
        rho;
        
        % estimacion de Codelco
        LocR;
        origin_time;
        
        % lista de geonsensores
        gss;
        
        
        first_time                      % tiempo de la primera medicion
        last_time                       % tiempo de la ultima medicion
                      % posicion y tiempo inicial
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
        
        % parametros de estimacion de la fuente
        src;
        filtsrc;
        err;
        
        % porcentaje de senal en cada eje rotado
        vr1;
        vr2;
        vr3;
        
        % elementos de la resolucion del sistema para la estimacion de la
        % fuente
        A       
    end
    
    methods
        function count = get.count(obj)
            count = length(obj.gss);
        end
        % class constructor
        function obj =  Event(name,alpha, beta, rho, LocR, origin_time, error, tail_per)
            obj.name = name;
            obj.alpha           = alpha;
            obj.beta            = beta;
            obj.rho             = rho;
            obj.LocR            = LocR;
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


