function [q,p,e,t,Bs,D]=combine_and_solve(dg, vertices, meshparams, funcs, edges, bodies, points, args)
    fprintf('INITIALIZING COMBINING\n');
    meshsize = meshparams.size;
    [p,e,t] = meshing(dg, meshsize);
    p1 = p(1,:);
    p2 = p(2,:);
    %hold on; pdemesh(p,e,t); axis equal;
    [K Bs D] = stiffness_matrix(p,e,t, meshparams.modulus, meshparams.poisson, meshparams.thickness, meshparams.type);
    f = zeros(size(K,1), 1);
    remove_these = [];
    for i = 1:numel(funcs)
        func = funcs{i};
        
        
        if strcmp(lower(func(1:4)),'edge')
            func_call = str2func(strcat('apply_',func));
            edges_this = edges{i};
            k2=[];
            for j = 1:numel(edges_this)
                edge = edges_this(j);
                dg_edge = dg(:,edge)';
                switch dg_edge(1)
                    case 2
                        x1=dg_edge(2);x2=dg_edge(3);y1=dg_edge(4);y2=dg_edge(5);
                        tol = min(sqrt((x1-x2)^2+(y1-y2)^2)/1000, meshsize);

                        dist =sqrt((p1*y1-p1*y2-p2*x1+p2*x2+x1*y2-x2*y1).^2/(x1^2-2*x1*x2+x2^2+y1^2-2*y1*y2+y2^2));
                        % Indices in the p matrix that lie on this edge
                        k1 = find(p(1,:) < max(x1,x2)+tol & p(1,:) > min(x1,x2)-tol & p(2,:) < max(y1,y2)+tol & p(2,:) > min(y1,y2)-tol & dist < tol);
                    case 1
                        x1=dg_edge(2);x2=dg_edge(3);y1=dg_edge(4);y2=dg_edge(5);
                        tol = min(sqrt((x1-x2)^2+(y1-y2)^2)/10, meshsize);
                        r = dg_edge(10); xc=dg_edge(8); yc=dg_edge(9);

                        R_comp =sqrt((p1-xc).^2+(p2-yc).^2);
                        % Indices in the p matrix that lie on this edge
                        k1 = find(p(1,:) < max(x1,x2)+tol & p(1,:) > min(x1,x2)-tol & p(2,:) < max(y1,y2)+tol & p(2,:) > min(y1,y2)-tol & R_comp < r+tol & R_comp > r-tol);
                end

                %pk = p(:,k1);
                k2 = [k2 find(ismember(e(1,:),k1) & ismember(e(2,:),k1))];
            end
            k2=unique(k2);
            [df,dK,strikes]=func_call(p,e(:,k2),args{i},K,f,meshparams);
            f = f+df;
            K = K+dK;
            remove_these = [remove_these; strikes(:)];
        end
        
        if strcmp(lower(func(1:5)),'point')
            func_call = str2func(strcat('apply_',func));
            points_this = points{i};
            k2=[];
            for j = 1:numel(points_this)
                point = points_this(j);
                vertex = vertices(point,:);
                
                tol = meshsize

                dist = sqrt((vertex(1)- p1).^2 + (vertex(2)- p2).^2);
                % Indices in the p matrix that lie on this edge
                [~,k1] = min(dist);

                k2 = [k2, k1];
            end
            [df,dK,strikes]=func_call(p,k2,args{i},K,f,meshparams);
            f = f+df;
            K = K+dK;
            remove_these = [remove_these; strikes(:)];
        end
        
        
    end
    remove_these=unique(remove_these);
    
    q = zeros(size(f,1),1);
    
    u = true(size(f,1),1);
    
    K(remove_these,:) = [];
    K(:,remove_these) = [];
    f(remove_these) = [];
    u(remove_these) = 0;    
    
    q_solved = K\f;
    q(u) = q_solved;