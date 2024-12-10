function varargout = Phasing(varargin)
% PHASING MATLAB code for Phasing.

% Edit the above text to modify the response to help Phasing

% Last Modified by GUIDE v2.5 03-Jul-2015 09:02:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Phasing_OpeningFcn, ...
                   'gui_OutputFcn',  @Phasing_OutputFcn, ...
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

% --- Executes just before Phasing is made visible.
function Phasing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Phasing (see VARARGIN)

% Choose default command line output for Phasing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

F=varargin{1};
S=varargin{2};

setappdata(handles.Phasing,'Frequency',F);
setappdata(handles.Phasing,'Spectrum',S);

pv=(max(F)+min(F))/2; % Set the pivot to the centre of the spectrum
set(handles.pv,'String',num2str(pv,'%3.2f'));
setappdata(handles.Phasing,'phasePivot',pv);

th0=str2double(get(handles.th0,'String'));
set(handles.th0Slider,'Value',th0);
setappdata(handles.Phasing,'phaseCorrection0',th0); 

th1=str2double(get(handles.th1,'String'));
set(handles.th1Slider,'Value',th1);
setappdata(handles.Phasing,'phaseCorrection1',th1);

sn=floor(abs(th1/360))+1;
setappdata(handles.Phasing,'th1Sensitivity',sn);

plotSpectrum(handles.axes1,F,S);
uiwait(handles.Phasing);

% --- Outputs from this function are returned to the command line.
function varargout = Phasing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
th0=getappdata(handles.Phasing,'phaseCorrection0');
th1=getappdata(handles.Phasing,'phaseCorrection1');
pv=getappdata(handles.Phasing,'phasePivot');

varargout{1}=th0;
varargout{2}=th1;
varargout{3}=pv;

delete(handles.Phasing);


% --- Executes on button press in cancelPhasing.
function cancelPhasing_Callback(hObject, eventdata, handles)
% hObject    handle to cancelPhasing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.Phasing,'phaseCorrection0',0);
setappdata(handles.Phasing,'phaseCorrection1',0);
setappdata(handles.Phasing,'phasePivot',0);

uiresume(handles.Phasing);

% --- Executes on button press in finishPhasing.
function finishPhasing_Callback(hObject, eventdata, handles)
% hObject    handle to finishPhasing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.Phasing);

% --- Executes on slider movement.
function th0Slider_Callback(hObject, eventdata, handles)
% hObject    handle to th0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

th0=get(hObject,'Value');

setappdata(handles.Phasing,'phaseCorrection0',th0);
set(handles.th0,'String',num2str(th0,'%3.2f'));

th1=getappdata(handles.Phasing,'phaseCorrection1');
pv=getappdata(handles.Phasing,'phasePivot');

F=getappdata(handles.Phasing,'Frequency');
S=getappdata(handles.Phasing,'Spectrum');

S=phaseSpectrum0(S,th0);
S=phaseSpectrum1(S,F,th1,pv);
setappdata(handles.Phasing,'phasedSpectrum',S);

plotSpectrum(handles.axes1,F,S);

% --- Executes during object creation, after setting all properties.
function th0Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th0Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function th1Slider_Callback(hObject, eventdata, handles)
% hObject    handle to th1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

th1=get(hObject,'Value');

setappdata(handles.Phasing,'phaseCorrection1',th1);
set(handles.th1,'String',num2str(th1,'%3.2f'));

th0=getappdata(handles.Phasing,'phaseCorrection0');
pv=getappdata(handles.Phasing,'phasePivot');

F=getappdata(handles.Phasing,'Frequency');
S=getappdata(handles.Phasing,'Spectrum');

S=phaseSpectrum0(S,th0);
S=phaseSpectrum1(S,F,th1,pv);
setappdata(handles.Phasing,'phasedSpectrum',S);

plotSpectrum(handles.axes1,F,S);

% --- Executes during object creation, after setting all properties.
function th1Slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th1Slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in setPivot.
function setPivot_Callback(hObject, eventdata, handles)
% hObject    handle to setPivot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y]=ginput(1);

set(handles.pv,'String',num2str(x,'%3.2f'));
setappdata(handles.Phasing,'phasePivot',x);

% --- Executes on button press in increaseSensitivity.
function increaseSensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to increaseSensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sn=getappdata(handles.Phasing,'th1Sensitivity');
sn=sn*2.;
setappdata(handles.Phasing,'th1Sensitivity',sn);
    
set(handles.th1Slider,'SliderStep', [1/(720*sn) 1/(720*sn)]);
set(handles.th1Slider,'Max',360*sn);
set(handles.th1Slider,'Min',-360*sn);

function th0_Callback(hObject, eventdata, handles)
% hObject    handle to th0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of th0 as text
%        str2double(get(hObject,'String')) returns contents of th0 as a double

% --- Executes during object creation, after setting all properties.
function th0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function th1_Callback(hObject, eventdata, handles)
% hObject    handle to th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of th1 as text
%        str2double(get(hObject,'String')) returns contents of th1 as a double

% --- Executes during object creation, after setting all properties.
function th1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to th1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function pv_Callback(hObject, eventdata, handles)
% hObject    handle to pv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pv as text
%        str2double(get(hObject,'String')) returns contents of pv as a doubl

% --- Executes during object creation, after setting all properties.
function pv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
