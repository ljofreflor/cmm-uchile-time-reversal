Events = importEvents();
nSrc = 256;
dt = .0005;
event = Events(1);
vectors = [];
for ii = 1:event.count
    [src{ii}, cutsrc{ii}, filtsrc{ii},cutfiltsrc{ii}, error{ii}, alphas{ii}] = source(event, nSrc, dt, ii);
    vectors = [vectors; alphas{ii}];
end

fuentes = horzcat(alphas{:})
plotSrc(event.origin_time, src{1});

% mediante k medias encontrar el conjunto de mediones m'as consistentes
[idx,ctrs] = kmeans(vectors,3);

% convertir los centroides a fuentes y comparar
