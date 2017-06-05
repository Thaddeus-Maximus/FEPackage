function [p,e,t] = meshing(dg, size)

    
%dg=decomposed_geometry(filename);
%pdegplot(dg,'EdgeLabels','on','SubdomainLabels','on');
%axis equal

[p,e,t] = initmesh(dg,'Hmax',size);