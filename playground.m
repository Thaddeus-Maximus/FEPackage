clear all
close all
clc

% gd = [1 1 0 0 1 0 0 0 0 1;...
%       1 0 -1 1 0 0 0 0 0 1;...
%       1 -1 0 0 -1 0 0 0 0 1;...
%       1 0 1 -1 0 0 0 0 0 1]';
%   
%   decsg(gd)

[p,e,t]=initmesh('lshapeg'); %,'hmax',inf)
[p,e,t]=refinemesh('lshapeg',p,e,t);
% p=jigglemesh(p,e,t,'opt','mean','iter',inf)

pdemesh(p,e,t)

points = p
edges = e(:,1:10)

args = [10 -50] 

[df,dK,strikes] = apply_edge_force(points,edges,args)