function dg = decomposed_geometry(filename)

[rawlines,circles,arcs] = thad_dxf(filename)

dg=zeros(12,1);
j=1;
for i = 1:size(rawlines,1)
    dg(1,j) = 2; % line code
    
    % x1 x2 y1 y2
    dg(2,j) = rawlines(i,2);
    dg(3,j) = rawlines(i,5);
    dg(4,j) = rawlines(i,3);
    dg(5,j) = rawlines(i,6);
    
    % region label to left, region label to right (0 is exterior label)
    dg(6,j) = 0;
    dg(7,j) = 1;
    
    dg(8:12,j) = 0;
    j=j+1;
end

%circles=[]


% id x_center y_center z_center radius start_angle end_angle (start and end angles
for i = 1:size(circles,1)
    dg(1,j:j+3) = 1; % circle code
    
    % x1 x2 y1 y2
    dg(2,j) = circles(i,2)+circles(i,5);
    dg(3,j) = circles(i,2);
    dg(4,j) = circles(i,3);
    dg(5,j) = circles(i,3)+circles(i,5);
    
    dg(2,j+1) = circles(i,2);
    dg(3,j+1) = circles(i,2)-circles(i,5);
    dg(4,j+1) = circles(i,3)+circles(i,5);
    dg(5,j+1) = circles(i,3);
    
    dg(2,j+2) = circles(i,2)-circles(i,5);
    dg(3,j+2) = circles(i,2);
    dg(4,j+2) = circles(i,3);
    dg(5,j+2) = circles(i,3)-circles(i,5);
    
    dg(2,j+3) = circles(i,2);
    dg(3,j+3) = circles(i,2)+circles(i,5);
    dg(4,j+3) = circles(i,3)-circles(i,5);
    dg(5,j+3) = circles(i,3);
    
    % region label to left, region label to right (0 is exterior label)
    dg(6,j:j+3) = 0;
    dg(7,j:j+3) = 1;
    
    dg(8,j:j+3) = circles(i,2);
    dg(9,j:j+3) = circles(i,3);
    dg(10,j:j+3) = circles(i,5);
    
    dg(11:12,j:j+3) = 0;
    j=j+4;
end

for i = 1:size(arcs,1)
    dg(1,j)=1; % circle code
    
    tol = 1e-3;
    
    x1 = arcs(i,2)+cosd(arcs(i,6))*arcs(i,5);
%     [~,idx] = find(abs(dg(3,:)-x1)<tol);
%     if ~isempty(idx)
%         x1=dg(3,idx(1))
%     end
    dg(2,j) = x1;
    
    x2 = arcs(i,2)+cosd(arcs(i,7))*arcs(i,5);
%     [~,idx] = find(abs(dg(2,:)-x2)<tol);
%     if ~isempty(idx)
%         x2=dg(2,idx(1))
%     end
    dg(3,j) = x2;
    
    y1 = arcs(i,3)+sind(arcs(i,6))*arcs(i,5);
%     [~,idx] = find(abs(dg(5,:)-y1)<tol);
%     if ~isempty(idx)
%         y1=dg(5,idx(1))
%     end
    dg(4,j) = y1;
    
    y2 = arcs(i,3)+sind(arcs(i,7))*arcs(i,5);
%     [~,idx] = find(abs(dg(4,:)-y2)<tol);
%     if ~isempty(idx)
%         y2=dg(4,idx(1))
%     end
    dg(5,j) = y2;
    
    
    dg(6,j)=0;
    dg(7,j)=1;
    
    dg(8,j)=arcs(i,2);
    dg(9,j)=arcs(i,3);
    dg(10,j)=arcs(i,5);
    
    dg(11:12,j) = 0;
    j=j+1;
end