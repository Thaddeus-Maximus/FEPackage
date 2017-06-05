function [df,dK,strikes]=apply_edge_force(points,edges,args,K,f,meshparams)
%% Inputs:
% points, the entire p matrix from the mesh.
% edges, the columns from the e matrix. recall rows 1 and 2 of this matrix
% contain the indices of the p matrix for start and end points.
% args, a list of forces (x, then y)
%% Outputs:
% df, a change in the forcing vector (set to zeroes if not used)
% dK, a change in the stiffness matrix (set to zeroes if not used)
% strikes, entries of the system of eqns to remove (set to empty list if
% not used)
% fprintf('congrats u fuk\n')
% points
% edges
% args

%% Now comes the fun gaussian quadrature or whatever...

% calculating overall length of edge(s)

L = 0; % overall length of edge(s)

%keyboard

for i = 1:size(edges,2)
    
    [idx] = edges(1:2,i);
    L = L + sqrt((points(1,idx(2)) - points(1, idx(1)))^2 + (points(2,idx(2)) - points(2,idx(1)))^2);
    
end

% calculating unit force vector (based on length of edge) and placing in
% nodal force vector where needed 

args_ul = args(1) * meshparams.thickness;
dof = size(points,2)*2;
df = zeros(dof,1); 

for i = 1:size(edges,2)

    [idx] = edges(1:2,i);
    dx=(points(1,idx(2)) - points(1,idx(1)));
    dy=(points(2,idx(2)) - points(2,idx(1)));
    l = sqrt(dx^2 + dy^2); % length of this edge
    % projection factorizing
    pf = [dy/l; -dx/l];
    
    df(2*idx(1)-1:2*idx(1)) = args_ul*pf*l/2 + df(2*idx(1)-1:2*idx(1));
    df(2*idx(2)-1:2*idx(2)) = args_ul*pf*l/2 + df(2*idx(2)-1:2*idx(2));
    
end

dK = 0
strikes = [];

