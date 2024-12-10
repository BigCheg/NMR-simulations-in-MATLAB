function varargout = RemoveDC(varargin)
% REMOVEDC MATLAB code for removedc.fig
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help removedc

% Last Modified by GUIDE v2.5 12-Nov-2015 10:57:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RemoveDC_OpeningFcn, ...
                   'gui_OutputFcn',  @RemoveDC_OutputFcn, ...
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

% --- Executes just before removedc is made visible.
function RemoveDC_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

T=varargin{1};
FID=varargin{2};

setappdata(handles.RemoveDC,'Time',T);
setappdata(handles.RemoveDC,'FID',FID);
setappdata(handles.RemoveDC,'amplitude',1.);
setappdata(handles.RemoveDC,'width',0.);

plotWindow(handles.axes1,T,FID);
uiwait(handles.RemoveDC);

% --- Outputs from this function are returned to the command line.
function varargout = RemoveDC_OutputFcn(hObject, eventdata, handles) 

lb=getappdata(handles.RemoveDC,'amplitude');
A=getappdata(handles.RemoveDC,'width');

varargout{1}=A;
varargout{2}=lb;

delete(handles.RemoveDC);

function amplitude_Callback(hObject, eventdata, handles)

T=getappdata(handles.RemoveDC,'Time');
FID=getappdata(handles.RemoveDC,'FID');
lb=getappdata(handles.RemoveDC,'width');

A=str2double(get(handles.amplitude,'String'));
wf=A*exp(-T*pi*lb);

setappdata(handles.RemoveDC,'amplitude',A);

plotWindow(handles.axes1,T,FID,wf);

% --- Executes during object creation, after setting all properties.
function amplitude_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function width_Callback(hObject, eventdata, handles)

T=getappdata(handles.RemoveDC,'Time');
FID=getappdata(handles.RemoveDC,'FID');
A=getappdata(handles.RemoveDC,'amplitude');

lb=str2double(get(handles.width,'String'));
wf=A*exp(-T*pi*lb);

setappdata(handles.RemoveDC,'width',lb);

plotWindow(handles.axes1,T,FID,wf);


% --- Executes during object creation, after setting all properties.
function width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancelRemoveDC.
function cancelRemoveDC_Callback(hObject, eventdata, handles)

setappdata(handles.RemoveDC,'amplitude',1.);
setappdata(handles.RemoveDC,'width',0.);

uiresume(handles.RemoveDC);

% --- Executes on button press in finishRemoveDC.
function finishRemoveDC_Callback(hObject, eventdata, handles)

uiresume(handles.RemoveDC);