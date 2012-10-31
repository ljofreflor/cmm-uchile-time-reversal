% presición de la estimación
nSrc = 256;
dt = .0005;

% generar un una fuente y reestimar el sensor con dicha fuente

[src, cutsrc, filtsrc, cutfiltsrc, error, alphas] = source(Events(1), nSrc, dt, 1);


% con dicha fuente se desea reestimar el sensor 1
[gsRec, gsReal] = recon(event,1,src);
