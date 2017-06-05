function [df dK strikes] = apply_edge_displacement(points,edges,args,K,f,meshparams)
%% Inputs:
% points, the entire p matrix from the mesh.
% edges, the columns from the e matrix. recall rows 1 and 2 of this matrix
% contain the indices of the p matrix for start and end points.
% args, list of displacements (x, y) 
%% Outputs:
% df, a change in the forcing vector (set to zeroes if not used)
% dK, a change in the stiffness matrix (set to zeroes if not used)
% strikes, entries of the system of eqns to remove (set to empty list if
% not used)

dof = size(points,2)*2;
df = zeros(dof,1); 
dK = zeros(dof,dof); 
strikes = [];
Kf = max(max(abs(K)))*10^6;

% find max abs value, multiply by 10^6
% good rcond is like, above 10^-10

%keyboard


for m = 1:size(edges,2)
    
    % Finding indexes of points corresponding to constrained pts
    idx = [idx; edges(1:2,i)];
    
        for i = 1:size(idx,1)

            df(2*idx(i),1) = Kf*args(1:2,m);
            dK(2*idx(i):2*idx(i)+1,:) = Kf*args(1:2,m)^2;
            dK(:,2*idx(i):2*idx(i)+1) = Kf*args(1:2,m)^2;

        end
        
end



