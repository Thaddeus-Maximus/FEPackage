function varargout = Loader(varargin)
% LOADER MATLAB code for Loader.fig
%      LOADER, by itself, creates a new LOADER or raises the existing
%      singleton*.
%
%      H = LOADER returns the handle to a new LOADER or the handle to
%      the existing singleton*.
%
%      LOADER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LOADER.M with the given input arguments.
%
%      LOADER('Property','Value',...) creates a new LOADER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Loader_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Loader_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Loader

% Last Modified by GUIDE v2.5 16-May-2017 10:03:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Loader_OpeningFcn, ...
                   'gui_OutputFcn',  @Loader_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Loader is made visible.
function Loader_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Loader (see VARARGIN)

% Choose default command line output for Loader
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using Loader.
%if strcmp(get(hObject,'Visible'),'off')
%    plot(rand(5));
%end

% UIWAIT makes Loader wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Loader_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in button_load_.
function button_load_dxf_Callback(hObject, eventdata, handles)
[filename,pathname] = uigetfile({'*.dxf'},'File Selector')
dg=decomposed_geometry(filename);
vertices = [];
for i=1:size(dg,2)
    vertices = [vertices; dg(2,i) dg(4,i); dg(3,i) dg(5,i)];
end
vertices
vertices = uniquetol(vertices, 'ByRows',true)
handles.dg = dg;
handles.vertices = vertices;
guidata(hObject, handles);

axes(handles.axes1);
cla;     
pdegplot(handles.dg,'EdgeLabels','on');
hold on
for i=1:size(handles.vertices,1)
    text(handles.vertices(i,1),handles.vertices(i,2),sprintf('P%d',i));
end
axis equal;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_solve.
function button_solve_Callback(hObject, eventdata, handles)
% hObject    handle to button_solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % circle: x^2+y^2 thing
    % line: vector projection, plus circle check at endpoints
    % arcs: 
    loadcodes = get(handles.edit1,'string');
    for i = 1:size(loadcodes,1)
        loadcode=loadcodes(i,:);
        splitcode = strsplit(loadcode);
        phase = 1;
        args{i} = [];
        
        edges{i} = [];
        bodies{i} = [];
        points{i} = [];
        
        for j=1:numel(splitcode)
            if strcmp(splitcode{j},';')
                phase=phase+1;
                continue
            end
            switch phase
                case 1
                    seq = splitcode{j};
                    if strcmp(lower(seq(1)),'b')
                         bodies{i}=[bodies{i} str2num(seq(2:end))];
                    elseif strcmp(lower(seq(1)),'p')
                         points{i}=[points{i} str2num(seq(2:end))];
                    else
                         edges{i}=[edges{i} str2num(seq(2:end))];
                    end
                case 2
                    funcs{i} = lower(splitcode{j});
                case 3
                    args{i} = [args{i} str2num(splitcode{j})];
                otherwise
                    
            end 
        end
        
    end
    
    meshparams = struct('size', str2num(get(handles.edit_meshsize,'string')), ...
        'thickness', str2num(get(handles.edit_thickness,'string')), ...
        'modulus', str2num(get(handles.edit_modulus,'string')), ...
        'poisson', str2num(get(handles.edit_poisson,'string')), ...
        'type', get(handles.popup_analysistype, 'Value') );
    
    [q_solution,p,e,t,Bs,D]=combine_and_solve(handles.dg, handles.vertices, meshparams, funcs, edges, bodies, points, args);
    handles.q_solution=q_solution;
    handles.p=p;
    handles.e=e;
    handles.t=t;
    handles.Bs=Bs;
    handles.D = D;
    guidata(hObject, handles);


% --- Executes on selection change in listbox2. Results and postprocessing.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
    
if hObject.Value == 1
    axes(handles.axes1);
    cla;     
    pdegplot(handles.dg,'EdgeLabels','on');
    hold on
    for i=1:size(handles.vertices,1)
        text(handles.vertices(i,1),handles.vertices(i,2),sprintf('P%d',i));
    end
    axis equal;
    return;
end

q = handles.q_solution;

use_tris = 0;

switch(hObject.Value-1)
    case 1
        % x displacement
        q_x = q(1:2:end);
        xydat = q_x;
    case 2
        % y dispalcement
        q_y = q(2:2:end);
        xydat = q_y;
    case 3
        % total displacement
        q_x = q(1:2:end);
        q_y = q(2:2:end);
        q_tot = sqrt(q_x.^2 + q_y.^2);
        xydat = q_tot;
    case 4
        % X strain
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b_x{i} = handles.Bs{i}(1,:);
            str_x(i) = b_x{i}*q_elem;
        end
        xydat = str_x;
        use_tris = 1;
    case 5
        % Y strain
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b_y{i} = handles.Bs{i}(2,:);
            str_y(i) = b_y{i}*q_elem;
        end
        xydat = str_y;
        use_tris = 1;
    case 6
        % Z strain
    case 7
        % Shear strain
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b_tau{i} = handles.Bs{i}(3,:);
            shr_str(i) = b_tau{i}*q_elem;
        end
        xydat = shr_str;
        use_tris = 1;
    case 8
        % X Stress
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b{i} = handles.Bs{i}(:,:);
            str = b{i}*q_elem;
            stress_x(i) = handles.D(1,:)*str;
        end
        xydat = stress_x;
        use_tris = 1;
    case 9
        % Y Stress
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b{i} = handles.Bs{i}(:,:);
            str = b{i}*q_elem;
            stress_y(i) = handles.D(2,:)*str;
        end
        xydat = stress_y;
        use_tris = 1;
    case 10
        % Z Stress
    case 11
        % Shear stress
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b{i} = handles.Bs{i}(:,:);
            str = b{i}*q_elem;
            stress_shr(i) = handles.D(3,:)*str;
        end
        xydat = stress_shr;
        use_tris = 1;
    case 12
        % von-Mises Stress
        for i = 1:numel(handles.Bs)
            t = handles.t(:,i);
            q_elem = q([t(1)*2 - 1; t(1)*2; t(2)*2-1; t(2)*2; t(3)*2-1; t(3)*2]);
            b{i} = handles.Bs{i}(:,:);
            str = b{i}*q_elem;
            stress = handles.D*str;
            sig_vm(i) = sqrt(stress(1)^2 - stress(1)*stress(2) + stress(2)^2 + 3*stress(3)^2);
        end
        xydat = sig_vm; 
        use_tris = 1;
        
        
end

mesh = 'off'
if get(handles.mesh_checkbox, 'Value');
    mesh = 'on'
end

fprintf('\nMin: %.5e \nMax: %.5e\n', min(xydat(:)), max(xydat(:)));
    
axes(handles.axes1);
cla;     
if use_tris
    pdeplot(handles.p,handles.e,handles.t, 'XYData',xydat, 'Mesh',mesh,'ColorMap','jet', 'XYStyle','flat','ZStyle','discontinuous');
else
    pdeplot(handles.p,handles.e,handles.t, 'XYData',xydat, 'Mesh',mesh,'ColorMap','jet', 'XYStyle','interp','ZStyle','continuous');
end
hold on
axis equal;
view(0,90);
    
% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_analysistype.
function popup_analysistype_Callback(hObject, eventdata, handles)
% hObject    handle to popup_analysistype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_analysistype contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_analysistype


% --- Executes during object creation, after setting all properties.
function popup_analysistype_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_analysistype (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_thickness_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thickness as text
%        str2double(get(hObject,'String')) returns contents of edit_thickness as a double


% --- Executes during object creation, after setting all properties.
function edit_thickness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thickness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_modulus_Callback(hObject, eventdata, handles)
% hObject    handle to edit_modulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_modulus as text
%        str2double(get(hObject,'String')) returns contents of edit_modulus as a double


% --- Executes during object creation, after setting all properties.
function edit_modulus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_modulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_poisson_Callback(hObject, eventdata, handles)
% hObject    handle to edit_poisson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_poisson as text
%        str2double(get(hObject,'String')) returns contents of edit_poisson as a double


% --- Executes during object creation, after setting all properties.
function edit_poisson_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_poisson (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_meshsize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_meshsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_meshsize as text
%        str2double(get(hObject,'String')) returns contents of edit_meshsize as a double


% --- Executes during object creation, after setting all properties.
function edit_meshsize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_meshsize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in button_load_fem.
function button_load_fem_Callback(hObject, eventdata, handles)
% hObject    handle to button_load_fem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] = uigetfile({'*.fem'},'Loading .fem')
imported=importdata(filename);
handles.dg=imported.dg;
handles.vertices=imported.vertices;
handles.p=imported.p;
handles.e=imported.e;
handles.t=imported.t;
handles.D=imported.D;
handles.Bs=imported.Bs;
handles.q_solution=imported.q_solution;
meshparams=imported.meshparams;
guidata(hObject, handles);

axes(handles.axes1);
cla;     
pdegplot(handles.dg,'EdgeLabels','on');
hold on
for i=1:size(handles.vertices,1)
    text(handles.vertices(i,1),handles.vertices(i,2),sprintf('P%d',i));
end
axis equal;

set(handles.edit1,'string',imported.loadcodes);
set(handles.edit_meshsize,'string',num2str(meshparams.size));
set(handles.edit_thickness,'string',num2str(meshparams.thickness));
set(handles.edit_modulus,'string',num2str(meshparams.modulus));
set(handles.edit_poisson,'string',num2str(meshparams.poisson));
set(handles.popup_analysistype,'Value',meshparams.type);


% --- Executes on button press in button_save_fem.
function button_save_fem_Callback(hObject, eventdata, handles)
% hObject    handle to button_save_fem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

dg=handles.dg;
vertices=handles.vertices;
p=handles.p;
e=handles.e;
t=handles.t;
D=handles.D;
Bs=handles.Bs;
q_solution=handles.q_solution;

loadcodes = get(handles.edit1,'string');
meshparams = struct('size', str2num(get(handles.edit_meshsize,'string')), ...
        'thickness', str2num(get(handles.edit_thickness,'string')), ...
        'modulus', str2num(get(handles.edit_modulus,'string')), ...
        'poisson', str2num(get(handles.edit_poisson,'string')), ...
        'type', get(handles.popup_analysistype, 'Value') );
    
[filename,pathname] = uiputfile({'*.fem'},'Saving .fem')
save(filename,'dg','vertices','p','e','t','D','Bs','q_solution','loadcodes','meshparams');


% --- Executes on button press in mesh_checkbox.
function mesh_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to mesh_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mesh_checkbox
