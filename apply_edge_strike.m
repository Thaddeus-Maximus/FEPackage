function [df,dK,strikes]=apply_edge_strike(points,edges,args,K,f,meshparams)
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


% calculating unit force vector (based on length of edge) and placing in
% nodal force vector where needed 

dof = size(points,2)*2;
df = zeros(dof,1); 
dK = zeros(dof,dof);
strikes = [];

for i = 1:size(edges,2)
    switch args(1)
        case 1
            strikes = [strikes; edges(1:2,i)*2-1];
        case 2
            strikes = [strikes; edges(1:2,i)*2];
        case 3
            strikes = [strikes; edges(1:2,i)*2-1; edges(1:2,i)*2];    
    end
end



