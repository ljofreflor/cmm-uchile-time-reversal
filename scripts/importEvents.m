function events = importEvents()
% CARGAR GEOSENSORES DESDE LA RUTA GENERADA POR PYTHON
% ------------------------------------------------------------------------%
% root_path es la ruta en donde se encuentran todos los eventos generados
% por la aplicación en python.
cd ..
cd eventos' en txt'
root_path = pwd;
cd ..
cd matlab

%-------------------------------------------------------------------------%
% list_dir es la lista de los nombres de todos los archivos y directorios
% que se encuentrarn en root_path, los dos primeros elementos de dicha lista son
% los retornos a la raiz por lo que se eliminarán de la lista.
list_dir = dir(root_path);
%
% list_dir.names tiene que retornar varios elementos del tipo
% 2011_apr_10_07_52
% con su respectiva carpeta
% 2011_apr_10_07_52 FOLDER
% que respectivamente son el archivo de donde de van a leer los datos y la
% carpeta con el mismo nombre en donde están guardados los resultados.

% Se guardan los nombres de los directorios en donde hay que leer la
% informaci'on que se debe almacenar en lo objeto, si el archivo es un
% dorectorio debe almacenarse en la lista "listdirnames"
i = 1;
for jj = find([list_dir.isdir] == 1)
    listdirnames{i} = list_dir(jj).name;
    i = i + 1;
end
listdirnames = {listdirnames{3:end}};

% se almacenan los datos en el objeto Events Data, los primeros dos
% directorios son los directorios de navegaci'on "." y ".." por lo que se
% ignoran haciendo iterar el vector desde 3
% cargar los eventos en el objeto events
events = [];
Nevents = size(listdirnames,2);

for ii = 1:Nevents
    % ruta de la carpeta con los datos del evento
    filePath= strcat([root_path '/' listdirnames{ii}]);
    filesNames = dir(filePath); filesNames = filesNames(3:end);
    for jj = 1:size(filesNames,1)
        Eventsdata{ii,jj} = importdata([filePath '/' filesNames(jj).name]);
    end
    
    % es necesario conocer cuantos de estos archivos son realmente datos y
    % cuales son parametros
    
    expr = [{filesNames.name}];
    Ngs = sum(cellfun(@sum,regexp(expr,'.*sismogram.txt')));

    % todos los dem'as archivos son parametros
    P_pick                 = Eventsdata{ii,Ngs + 1}.data;
    r                      = Eventsdata{ii,Ngs + 2};
    S_pick                 = Eventsdata{ii,Ngs + 3}.data;
    TriggerPosition        = Eventsdata{ii,Ngs + 4}.data;
    hardware_sampling_rate = Eventsdata{ii,Ngs + 5}.data;
    model_data             = Eventsdata{ii,Ngs + 6}.data;
    p_time                 = Eventsdata{ii,Ngs + 7}.data(:,4);
    s_time                 = Eventsdata{ii,Ngs + 8}.data(:,4);
    site_id                = Eventsdata{ii,Ngs + 9}.data;
    t_time                 = Eventsdata{ii,Ngs + 10}.data(:,4);
    valid_P                = Eventsdata{ii,Ngs + 11}.data;
    valid_S                = Eventsdata{ii,Ngs + 12}.data;
    valid_SP               = Eventsdata{ii,Ngs + 13}.data;
    alpha                  = model_data(1);
    beta                   = model_data(2);
    rho                    = model_data(3);
    % posición y tiempo estimados
    origin_time = model_data(4);
    LocR = [model_data(5), model_data(6), model_data(7)];
    error = 0.15;
    tail_per = 0.0;
    events = [events Event(alpha,beta,rho,LocR,origin_time, error, tail_per)];
    
    % Cada evento tiene una cantidad variable de sensores que obtienen
    % mediciones, sabemos que todos los archivos que contengan por nombre
    % la cadena "*sismogram.txt" son sensores con mediciones.
    
    for kk = 1:Ngs
        M  = Eventsdata{ii,kk};
        sensorData  = M(:,3:5);
        r0 = [r(kk,1) r(kk,2) r(kk,3)];
        
        % Se crea un objeto del tipo sensor
        gs  = Geosensor(r0, t_time(kk), hardware_sampling_rate(kk),...
            TriggerPosition(kk), p_time(kk), s_time(kk),valid_P(kk),...
            valid_S(kk), valid_SP(kk), site_id(kk)); 
        
        % demasiados parametros en el constructor hacen ilegible y poco
        % mantenible el c`odigo
        
        % se agregar el geosensor conjunto de geosensores
        events(ii).addGeosensor(gs, sensorData);
    end
end
end





