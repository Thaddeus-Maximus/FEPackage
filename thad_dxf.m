function [lines,circles,arcs,timetaken] = thad_dxf(filename)
lines=[];
circles=[];
arcs=[];

% thaddxf 1.0
% very basic, but inteneded to do what it does in full
% i hate matlab

fid=fopen(filename); % open file. your job to add filepath to path
dxfdata=textscan(fid,'%s'); % read dxf file as cell array of strings
fclose(fid); % close file
dxfdata=dxfdata{1,1}; % reshape array

beg=strcmp('ENTITIES',dxfdata); % cut out dxf entity data block to increase speed and reduce required memory  
    if sum(beg)==0
        b=errordlg('corrupted dxf file, processing stopped ','file error');
        uiwait(b);clear;return
    end
beg=find(beg==1);               
endsec=strcmp('ENDSEC',dxfdata);
endsec=find(endsec==1);
endsec=endsec(endsec>beg);
endsec=endsec(1);
dxfdata=dxfdata(beg:endsec); 
clear beg endsec;

tic;
%%%%%%begin%%%%%%%%  get indices + total... 
% of line no's of all treated entities, total=all indices in ascend order+no of last line of dxf block  
points=strcmp('AcDbPoint',dxfdata); 
points=find(points==1);
    if isempty (points);
        clear points;
    else
        if exist ('total','var')==0
            total=(points);
        else
            total=[total;points];
        end         
    end
    
lines_starts=strcmp('AcDbLine',dxfdata);
lines_starts=find(lines_starts==1);
% id x1 y1 z1 x2 y2 z2
for i = 1:numel(lines_starts)
    j=lines_starts(i);
    lines(i,1)=i;
    while j<numel(dxfdata)
        if strcmp(dxfdata(j),'10')
            lines(i,2)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'20')
            lines(i,3)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'30')
            lines(i,4)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'11')
            lines(i,5)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'21')
            lines(i,6)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'31')
            lines(i,7)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'0')
            break;
        else
            j=j-1;
        end
        j=j+2;
    end
end

arcs=[];
circles=[];
circles_starts=strcmp('AcDbCircle',dxfdata);
circles_starts=find(circles_starts==1);
% id x_center y_center z_center radius start_angle end_angle (start and end angles
% are NaN if this is a circle, not an arc
for i = 1:numel(circles_starts)
    clear thiscircle
    j=circles_starts(i);
    thiscircle(1,1)=i;
    is_arc=0;
    while j<numel(dxfdata)
        if strcmp(dxfdata(j),'10')
            thiscircle(1,2)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'20')
            thiscircle(1,3)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'30')
            thiscircle(1,4)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'40')
            thiscircle(1,5)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'50')
            is_arc=1;
            thiscircle(1,6)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'51')
            is_arc=1;
            thiscircle(1,7)=str2double(dxfdata(j+1));
        elseif strcmp(dxfdata(j),'0')
            break;
        else
            j=j-1;
        end
        j=j+2;
    end
    if is_arc
        arcs = [arcs;thiscircle];
    else
        circles = [circles;thiscircle];
    end
end

timetaken = toc;