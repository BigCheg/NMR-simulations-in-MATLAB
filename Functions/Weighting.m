function varargout = Weighting(varargin)
% WEIGHTING MATLAB code for Weighting.fig
%      WEIGHTING, by itself, creates a new WEIGHTING or raises the existing
%      singleton*.
%
%      H = WEIGHTING returns the handle to a new WEIGHTING or the handle to
%      the existing singleton*.
%
%      WEIGHTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WEIGHTING.M with the given input arguments.
%
%      WEIGHTING('Property','Value',...) creates a new WEIGHTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Weighting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Weighting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Weighting

% Last Modified by GUIDE v2.5 03-Jul-2015 12:05:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Weighting_OpeningFcn, ...
                   'gui_OutputFcn',  @Weighting_OutputFcn, ...
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

% --- Executes just before Weighting is made visible.
function Weighting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Weighting (see VARARGIN)

% Choose default command line output for Weighting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

T=varargin{1};
FID=varargin{2};

setappdata(handles.Weighting,'Time',T);
setappdata(handles.Weighting,'FID',FID);
setappdata(handles.Weighting,'windowType','None');
setappdata(handles.Weighting,'windowParameter',0);

plotWindow(handles.axes1,T,FID);

uiwait(handles.Weighting);

% --- Outputs from this function are returned to the command line.
function varargout = Weighting_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

wt=getappdata(handles.Weighting,'windowType');
wp=getappdata(handles.Weighting,'windowParameter');

varargout{1}=wt;
varargout{2}=wp;

delete(handles.Weighting);

% --- Executes on button press in cancelWeighting.
function cancelWeighting_Callback(hObject, eventdata, handles)
% hObject    handle to cancelWeighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

setappdata(handles.Weighting,'windowType','None');
setappdata(handles.Weighting,'windowParameter',0);

uiresume(handles.Weighting);

% --- Executes on button press in finishWeighting.
function finishWeighting_Callback(hObject, eventdata, handles)
% hObject    handle to finishWeighting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.Weighting);

% --- Executes on selection change in windowType.
function windowType_Callback(hObject, eventdata, handles)
% hObject    handle to windowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
types=get(hObject,'String');
index=get(hObject,'Value');

FID=getappdata(handles.Weighting,'FID');
T=getappdata(handles.Weighting,'Time');
setappdata(handles.Weighting,'windowType',char(cellstr(types(index))));

switch getappdata(handles.Weighting,'windowType')
    case 'Exponential'
        set(handles.parameterName,'String','width:');
        set(handles.wp,'String','50');
        width=str2double(get(handles.wp,'String'));
        wf=exp(-T*pi*width);
    case 'Gaussian'
        set(handles.parameterName,'String','alpha:');
        set(handles.wp,'String','2.5');
        alpha=str2double(get(handles.wp,'String'));
        wf=generate(sigwin.gausswin(length(FID)*2,alpha));
        wf=wf(length(FID)+1:length(FID)*2,:);
    case 'Hanning'
        set(handles.parameterName,'String','');
        set(handles.wp,'String','-');
        wf=generate(sigwin.hann(length(FID)*2,'Periodic'));
        wf=wf(length(FID)+1:length(FID)*2,:);
    otherwise
        wf=zeros(size(FID));
end

setappdata(handles.Weighting,'windowParameter',str2double(get(handles.wp,'String')));

plotWindow(handles.axes1,T,FID,wf);

% --- Executes during object creation, after setting all properties.
function windowType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function wp_Callback(hObject, eventdata, handles)
% hObject    handle to wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

T=getappdata(handles.Weighting,'Time');
FID=getappdata(handles.Weighting,'FID');

switch getappdata(handles.Weighting,'windowType')
    case 'Exponential'
        width=str2double(get(handles.wp,'String'));
        wf=exp(-T*pi*width);
    case 'Gaussian'
        alpha=str2double(get(handles.wp,'String'));
        wf=generate(sigwin.gausswin(length(FID)*2,alpha));
        wf=wf(length(FID)+1:length(FID)*2,:);
    case 'Hanning'
        wf=generate(sigwin.hann(length(FID)*2,'Periodic'));
        wf=wf(length(FID)+1:length(FID)*2,:);
    otherwise
        wf=zeros(size(FID));
end

setappdata(handles.Weighting,'windowParameter',str2double(get(handles.wp,'String')));

plotWindow(handles.axes1,T,FID,wf);

% --- Executes during object creation, after setting all properties.
function wp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
