function [lines,C] = polygonizer(filename)
% clear all
% close all
% clc
% filename='platewithhole_curvy.dxf';
[rawlines,circles,arcs] = thad_dxf(filename);

lines=[];
for j=1:size(rawlines,1)
    line=rawlines(j,:);
    n_points=10;
    dx = (line(5) - line(2))/n_points;
    dy = (line(6) - line(3))/n_points;
    for i=0:n_points-1
        thisline = [i line(2)+dx*i line(3)+dy*i 0 line(2)+dx*(i+1) line(3)+dy*(i+1) 0];
        lines=[lines;thisline];
    end
    
end

for j=1:size(circles,1)
    circle=circles(j,:);
    n_points = 10;
    for i=0:n_points-1
        theta1 = 360/n_points*i;
        theta2 = 360/n_points*(i+1);
        r = circle(5);
        thisline = [i circle(2)+cosd(theta1)*r circle(3)+sind(theta1)*r 0 circle(2)+cosd(theta2)*r circle(3)+sind(theta2)*r 0];

        lines = [lines; thisline];
    end
end

% C = [(1:(nump-1))' (2:nump)'; nump 1];

for j=1:size(arcs,1)
    arc=arcs(j,:);
    n_points = 10;
    theta_start = arc(6);
    theta_end = arc(7);
    delta_theta = wrapTo360(theta_end-theta_start);
    for i=0:n_points-1
        theta1 = theta_start + delta_theta/n_points*i;
        theta2 = theta_start + delta_theta/n_points*(i+1);
        r = arc(5);
        thisline = [i arc(2)+cosd(theta1)*r arc(3)+sind(theta1)*r 0 arc(2)+cosd(theta2)*r arc(3)+sind(theta2)*r 0];

        lines = [lines; thisline];
    end
end



C=[];
n=size(lines,1);
tol=1e-8;
for i=1:n
    for j=1:n
        if i==j
            continue
        end
        if (abs(lines(i,2)-lines(j,5)) < tol) && (abs(lines(i,3)-lines(j,6)) < tol)
            C=[C; i,j];
        elseif (abs(lines(i,5)-lines(j,2)) < tol) && (abs(lines(i,6)-lines(j,3)) < tol)
            C=[C; i,j];
        end
    end
end

lines
C