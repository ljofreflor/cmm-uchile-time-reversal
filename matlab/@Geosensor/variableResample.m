function obj = variableResample(obj, error)
%SET_RESAMPLE Remuestro variable de los datos hasta que se cumpla el error
%--------------------------------------------------------------------------
% integrar y quitar la tendencia lineal de las mediciones del los
% sismogrados. Los sismogrados puedes medir desplazamiento, velocidad o
% aceleracion, pero hay que transformar todos a desplazamiento.

if obj.IsSpeedometer
    obj.r_x = detrend(cumsum(obj.data(:,1)))';
    obj.r_y = detrend(cumsum(obj.data(:,2)))';
    obj.r_z = detrend(cumsum(obj.data(:,3)))';    
elseif obj.IsAccelerometer    
    obj.r_x = detrend(cumsum(obj.data(:,1)))';
    obj.r_y = detrend(cumsum(obj.data(:,2)))';
    obj.r_z = detrend(cumsum(obj.data(:,3)))';
    
    obj.r_x = detrend(cumsum(obj.r_x));
    obj.r_y = detrend(cumsum(obj.r_y));
    obj.r_z = detrend(cumsum(obj.r_z));    
else
    obj.r_x = obj.data(:,1)';
    obj.r_y = obj.data(:,2)';
    obj.r_z = obj.data(:,3)';
end

% time vector es el tiempo en las que se hicieron las mediciones del
% geosensor.

obj.L = size(obj.data,1); % n de mediciones
tp = obj.TriggerPosition; 
hsr = obj.hardware_sampling_rate;

% vector de tiempo, tiene que retrodecer el buffer dado por "tp"
obj.timevector = obj.t_time + ((0:(obj.L-1))-tp)/hsr;
obj.firsttime = obj.timevector(1);
obj.lasttime = obj.timevector(end);
[~ ,obj.cuttime] = find_tail_limit(obj, 0.8);

% norma del vector de desplazamiento medici`on a medici'on
normDespla     = sqrt(obj.r_x.^2 + obj.r_y.^2 + obj.r_z.^2);

% el primer y último indice son los que se conservan en el remuestreo
resampleIndex  = [1 obj.L];

timeResample   = obj.timevector(resampleIndex);
normResample   = normDespla(resampleIndex);

normDesplaInterp   = interp1(timeResample,normResample, obj.timevector);
normDesplaDiff     = normDespla - normDesplaInterp;

% el error relativo producido por esa primera iteración de considerar solo la
% primera y ultima medicion sera el error inicial
er = (norm(normDesplaDiff,1))/norm(normDespla,1);
errorList = er;
while(er > error)
    % indice en donde ocurre una maxima amplitud del error producido
    newSampleIndex = find(abs(normDesplaDiff) == max(abs(normDesplaDiff)));
    % agregar ese indice al conjunto
    resampleIndex = unique([ resampleIndex newSampleIndex]);
    % vector de tiempo resampleado
    timeResample = obj.timevector(resampleIndex);
    % vector de norma resapleado
    normResample = normDespla(resampleIndex);    
    % interpolaci'on del tiempo remuestreado sobre el vector de tiempo
    % original
    normDesplaInterp = interp1(timeResample,normResample,obj.timevector);
    % diferencia producida por la interpolacion
    normDesplaDiff = abs(normDespla - normDesplaInterp);    
    % error de estimacion
    er = norm(normDesplaDiff,1)/norm(normDespla,1);
    errorList = [errorList er];
end

% reemplazar las mediciones reales con las resampleadas
obj.r_x = obj.r_x(resampleIndex);
obj.r_y = obj.r_y(resampleIndex);
obj.r_z = obj.r_z(resampleIndex);
obj.timeresamplevector   = obj.timevector(resampleIndex);

% almacenar los nuevos parámetros
obj.resampling_rate = 1./diff(obj.timeresamplevector);
obj.period = diff(obj.timeresamplevector);
obj.resampleSize = length(obj.timeresamplevector);
obj.resampleErrorOnNorm = errorList(end);
end

