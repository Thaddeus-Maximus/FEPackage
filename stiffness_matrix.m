function [K,Bs,D] = stiffness_matrix(points,edges,triangles, E,v,h,type)
Ne = size(edges,2);
Np = size(points,2);
Nt = size(triangles,2);
% pdemesh(points,edges,triangles);
% axis equal

% p is a matrix of points: each column is a point with x and y value
% e is edges: a 7xNe matrix of edges
% t is triangles: a 4xNt matrix of triangles. each column is the index of
% the point corresponding it

switch(type)
    case 1 % plane stress
        D=E/(1-v^2)*[1 v 0; v 1 0; 0 0 (1-v)/2];
    case 2 % plane strain
        D=E*(1-v)/((1+v)*(1-2*v))*[1 v/(1-v) 0; v/(1-v) 1 0; 0 0 (1-2*v)/(2*(1-v))];
    otherwise
        fprintf('Axissymetric not supported yet......');
end

K = zeros(Np*2);
Bs = {};

for nTri = 1:Nt
    tri = triangles(:,nTri);

    pts = [points(:,tri(1)); points(:,tri(2)); points(:,tri(3))];

    f = 0;
    qdpts = [-sqrt(1/3) sqrt(1/3)];
    for s = qdpts
        for t = qdpts
            dNds = [1/4*(1+t) -1/4*(1+t) 0];
            dNdt = [1/4*(1+s) 1/4*(1-s) -1/2];

            dxds = [1/4*(1+t) 0 -1/4*(1+t) 0 0 0]*pts;
            dxdt = [1/4*(1+s) 0 1/4*(1-s) 0 -1/2 0]*pts;
            dyds = [0 1/4*(1+t) 0 -1/4*(1+t) 0 0]*pts;
            dydt = [0 1/4*(1+s) 0 1/4*(1-s) 0 -1/2]*pts;

            J = [dxds dyds; dxdt dydt];
            ans = inv(J)*[dNds;dNdt];

            dNdx=ans(1,:);
            dNdy=ans(2,:);
            B=[dNdx(1) 0 dNdx(2) 0 dNdx(3) 0; 0 dNdy(1) 0 dNdy(2) 0 dNdy(3); dNdy(1) dNdx(1) dNdy(2) dNdx(2) dNdy(3) dNdx(3)];
            
            f=f+h*B'*D*B*det(J);
        end
    end
    Bs=[Bs, B];
    dofs = [tri(1:3,1)*2-1, tri(1:3,1)*2];
    for i=1:3
        for j=1:3
            K(dofs(i,:),dofs(j,:)) = K(dofs(i,:),dofs(j,:)) + f(i*2-1:i*2, j*2-1:j*2);
        end
    end
end

K;
