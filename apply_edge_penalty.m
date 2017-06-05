function [df dK strikes] = apply_edge_penalty(points,edges,args,K,f,meshparams)
%% Inputs:
% points, the entire p matrix from the mesh.
% edges, the columns from the e matrix. recall rows 1 and 2 of this matrix
% contain the indices of the p matrix for start and end points.
% args, a list of directions constrained (1 = x, 2 = y, 3 = both) 
%% Outputs:
% df, a change in the forcing vector (set to zeroes if not used)
% dK, a change in the stiffness matrix (set to zeroes if not used)
% strikes, entries of the system of eqns to remove (set to empty list if
% not used)

% Finding indexes of points corresponding to constrained pts
idx=[];
for i = 1:size(edges,2)
    
    idx = [idx; edges(1:2,i)];
%     const_x_pts = p(idx,1);
%     const_y_pts = p(idx,2);
    
end

dof = size(points,2)*2;
df = zeros(dof,1); 
dK = zeros(dof,dof); 
strikes = [];
Kf = max(max(abs(K)))*10^8;

% find max abs value, multiply by 10^6
% good rcond is like, above 10^-10

%keyboard


switch args(1)
    case 1
    
        for i = 1:size(idx,1)

%             df(2*idx(i),1) = Kf;
            dK(2*idx(i)-1,:) = Kf;
            dK(:,2*idx(i)-1) = Kf;

        end
    
    case 2
        
        for i = 1:size(idx,1)

%             df(2*idx(i)+1,1) = Kf;
            dK(2*idx(i),:) = Kf;
            dK(:,2*idx(i)) = Kf;

        end
    
    case 3 
        
        for i = 1:size(idx,1)

%             df(2*idx(i):2*idx(i)+1,1) = Kf;
            dK(2*idx(i)-1:2*idx(i),:) = Kf;
            dK(:,2*idx(i)-1:2*idx(i)) = Kf;

        end
end





    
        
     



