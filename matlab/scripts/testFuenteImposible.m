
if(size(Events) == 0)
    Events = importEvents();
end
event = Events(1);
% evento artificial y fuente artificial
[art, artsrc] = eventoArtificial(event);
nSrc = 250;
dt = 1/4800;
[src, cutsrc, filtsrc, filtcutsrc, error] = source(art, nSrc, dt, 1:art.count);