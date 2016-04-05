% Tag to whale frame guide:
% How to construct prh files

% Lat long converter:
% http://www.directionsmag.com/site/latlong-converter
%
% Geo Mag Converter
% http://www.ngdc.noaa.gov/geomagmodels/IGRF.jsp
%
% REMEMBER to rename DTG files to consecutive numbers. Good program for
% this is FileMenu Tools (freeware, downloadable). When installing, remove
% checkboxes from everything but "advanced renamer".
% Select all dtg files, right-click, choose filemenu tools and advanced
% renamer, then choose these settings:
% Change name - after old name, add sequence, 01 (choose a01 and remove a)
% add advanced option, choose replace, from position 6 to position 9.
% Correct sequence of files, check resulting file name, and press rename.


% DQ2012 QUICKSETTINGS
path = 'F:\tt12\tt12_320e\';
settagpath('audio',path(1:3));
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])

% Area-specific constants:
GMT2LOC   = -10;
DECL      = -9.712;
INCL      = 37.943;
FSTRENGTH = 35060;

% Deployment-specific constants:
tag       = 'tt12_320e';

% TIME (reported by tag)
TIME = [2012 11 15 14 52 43];

% Fill out degrees and decimal-minutes to compute decimal degrees
%lat       = [36 22.966];
%long      = -[03 12.607];
%TAGLOC    = [lat(1)+lat(2)/60 long(1)+long(2)/60]

% Or insert manually calculated decimal degrees
TAGLOC    = [21.21999 -157.773445];

% Construct CAL file
N=makecuetab(tag);
savecal(tag,'CUETAB',N) ;
savecal(tag,'GMT2LOC',GMT2LOC);
savecal(tag,'TAGLOC',TAGLOC);
savecal(tag,'DECL',DECL);

% Construct RAW file
[s,fs]=swvread(tag);
saveraw(tag,s,fs)

% Add path where tag calibration m-files are located
addpath('C:\Users\Julie\Documents\MATLAB\tags\')

% Construct tag-frame PRH file
% need to run the appropriate tag cal m-script
CAL = tag244 ;
%CAL = tag234;
[p,tempr,CAL] = calpressure(s,CAL,'full');


% Repeat the next two steps until std(M) is below 0.5 and std(A) is below 0.04
[M,CAL] = autocalmag(s,CAL) ;
[A,CAL] = autocalacc(s,p,tempr,CAL) ;

% TO USE SENSOR SUBSAMPLE:
% Define sensor subsample: use plott(p,fs), use ginput to get end second,
% then multiply by sensor sample rate, fs
% s_sub=s(1:lastsample,:)
% 
% Run calibration as normal, but with sensor subsample
% [p,tempr,CAL] = calpressure(s_sub,CAL,'full');
% [M,CAL] = autocalmag(s_sub,CAL) ;
% [A,CAL] = autocalacc(s_sub,p,tempr,CAL) ;
%
% Now, remake prh data with full sensor data
% [p,tempr,CAL] = calpressure(s,CAL,'none');
% [M,CAL] = autocalmag(s,CAL,'none') ;
% [A,CAL] = autocalacc(s,p,tempr,CAL,'none') ;


% When satisfied, save cal and prh file
savecal(tag,'CAL',CAL)
saveprh(tag,'p','tempr','fs','A','M')

% Evaluate sensors
d2evaluatesensors(tag)

% Get extra information for records
% Use tagaudit to place tagoff cue

%tag = 'gm13_008b'; R=loadaudit(tag); 
tagoff=findaudit(R,'tagoff'); tagon=findaudit(R,'tagon');
if isempty(tagon)
    tagon=0;
end
disp(['Tag Duration: ' num2str((tagoff(1)-tagon(1))/3600)])
getnumchips(tag,tagoff)