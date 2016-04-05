% Generate DTAG3 PRH and CAL file
% Online GEOMAG converter: http://www.ngdc.noaa.gov/geomag-web/#igrfwmm

% If paths are not already set, set them from the start
addpath('C:\Users\Julie\Documents\MATLAB\tag\d2matlab\')
addpath('C:\Users\Julie\Documents\MATLAB\tag\d3matlab\')
addpath('C:\Users\Julie\Documents\MATLAB\tag\d3matlab\dt3cals')
addpath('C:\Users\Julie\Documents\MATLAB\tag\XML4MATv2')

% settagpath('cal',['c:/tag/data/cal']);
% settagpath('raw',['c:/tag/data/raw']);
% settagpath('prh',['c:/tag/data/prh']);
% settagpath('audit',['c:/tag/data/audit']) ;

% QUICKSETTING:
clear, close all; clc

path = 'E:\bm15\bm15_054a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])
settagpath('audio','E:\')


author     = 'Michael Moore';
email      = 'mmoore@whoi.edu';
expedition = 'Chile Blue Whale Photogrammetry' ;

% Get magnetic parameters from GEOMAG converter (once per field trip)
% GET DECL INCL WHEN IN FIELD (CHANGES)
% http://www.ngdc.noaa.gov/geomag-web/#igrfwmm
DECL       = 10.4077;   % magnetic declination in degrees, - = West, + = East
INCL       = -43.5874;   % magnetic inclination in degrees
FSTRENGTH  = 27458.5; % total field strength, microTesla
UTC2LOC    = -4;

% Define tag deployment constants
tag = 'bm15_054a';
recdir = 'E:\bm15\bm15_054a'; % this will create errors if drive is mapped to different drive
prefix = 'bm054a';
df     = 10; % decimation factor


%%
% Define expedition specific information stored in cal files

% Define extra deployment specific information stored in cal file
location       = 'Chile';
ANIMAL.name    = '';
ANIMAL.gender  = 'F';
% ANIMAL.description = 'Large adult male';
% ANIMAL.age     = '';
TAGON.TIME     = [2015 2 23 18 58 07]; % Get this from xml field cue time, UTC
TAGON.ATTACHMENT = [2015 2 23 18 58 07]; % time tag attached to animal
TAGON.POSITION = [-44.09299 73.25058];
TAGON.PHOTO    = '';
TAGOFF = [2015 2 24 5 16 00];

% FLIGHT INFO
FLIGHT.UP = [2015 2 23 18 54 00]; % APH up
FLIGHT.OVER = [2015 2 23 18 58 13]; % First over whale
FLIGHT.DOWN = [2015 2 23 19 11 00]; % APH down
FLIGHT.BIOPSY = [2015 2 23 22 42 00]; % biopsy taken

%%

% READ SENSOR DATA
X   = d3readswv ( recdir , prefix , df ) ;

% FIND AND IMPLEMENT TAG CALIBRATION
[CAL,DEPLOY] = d3deployment ( recdir , prefix , tag ) ;

% PERFORM CALIBRATION OF TEMPERATURE AND PRESSURE
[p,CAL]=d3calpressure(X,CAL,'full');

% PERFORM CALIBRATION OF ACCELLEROMETERS AND MAGNETOMETERS
[A,CAL,fs] = d3calacc(X,CAL,'full',0.3); % Try mindepth of 0.3 for tursiops, but larger is better
[M,CAL] = d3calmag(X,CAL,'full',0.3);

%%
% SAVE PRH AND CAL DATA FOR AUDITING AND OTHER PROCESSING
saveprh(tag,'p','M','A','fs')
d3savecal(tag,'CAL',CAL);


%% ADD METADATA TO CAL FILE

% Who made files and recordings?
d3savecal(tag,'AUTHOR',author);
d3savecal(tag,'EMAIL',email);
d3savecal(tag,'EXPEDITION',expedition);

% What were the magnetic field characteristics of the expedition site?
d3savecal(tag,'DECL',DECL);
d3savecal(tag,'INCL',INCL);
d3savecal(tag,'FSTRENGTH',FSTRENGTH);
d3savecal(tag,'UTC2LOC',UTC2LOC)

% Where and when was it tagged?
d3savecal(tag,'LOCATION',location);
d3savecal(tag,'TAGON',TAGON)

% Trial information
d3savecal(tag,'FLIGHT',FLIGHT);



%%

% PERFORM TAG TO WHALE FRAME ROTATION OF ACC AND MAG
% AND ESTIMATE PITCH/ROLL/HEADING

% See tag2whale pdf file for these steps.

% Correct to actual OTAB found using prhpredictor
% PRH = prhpredictor (p,A,fs,4,2,'descent') ;
% OTAB = [1 0 mean(PRH(:,2)) mean(PRH(:,3)) mean(PRH(:,4))]; %avg orientation from prhpredictor

% If prhpredictor cannot be done, you can assume 
% assume ideal orientation, i.e. OTAB = [1 0 0 0 0]. 
OTAB = [1 0 0 0 0];

% Perform tag2whale rotation using OTAB, and save OTAB
[Aw,Mw] = tag2whale (A,M,OTAB,fs) ;
d3savecal(tag,'OTAB',OTAB);

% Now, do manual calculation of pitch/roll/heading

% report on trustworthiness of heading estimate
dp = (A.*M*[1;1;1])./norm2(M) ;
incl = asin(mean(dp)) ;     % do the mean before the asin to avoid problems
                           % when the specific acceleration is large
sincl = asin(std(dp)) ;
fprintf(' Mean Magnetic Field Inclination: %4.2f\260 (%4.2f\260 RMS)\n',...
       180/pi*incl, 180/pi*sincl) ;

% Calculate pitch, roll, heading, then correct for declination
[pitch roll] = a2pr(Aw) ;
[head vm incl] = m2h(Mw,pitch,roll) ;
if exist('DECL'),
   head = head + DECL*pi/180 ;      % adjust heading for declination angle in radians
else
    disp('Warning: No declination specified')
end

% Save complete PRH file
saveprh(tag,'p','A','M','fs','Aw','Mw','pitch','roll','head') ;
   




