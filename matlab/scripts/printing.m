
% graficas de la fuentes estimadas
for p = 1:length(Ev)
plotSrc(Ev(p).src,Ev(p).origin_time)
print('-painters', '-dpdf','-r600',['plotSrcEv', num2str(p) ,'src.pdf'])
end

% graficas de la fuentes estimadas filtradas y rotadas
for p = 1:length(Ev)
plotSrc(rotate(Ev(p).filtsrc),Ev(p).origin_time)
print('-painters', '-dpdf','-r600',['plotSrcEv', num2str(p) ,'filtrotsrc.pdf'])
end