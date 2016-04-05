% right whale UAS overflights
% Julie van der Hoop jvanderhoop@whoi.edu 1 April 2016
close all; clear all;

% set up presets
path = 'F:\eg16\eg16_048a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\']);
tag = 'eg16_048a';

% load data and cal/deploy information
loadprh(tag)
CAL = loadcal(tag);
CAL.TAGOFF = [2016 2 17 21 29 44];

%% Calculate time cues
FLIGHT.UP_cue = etime([2016 2 17 17 23 00],CAL.TAGON');
FLIGHT.OVER_cue = etime([2016 2 17 17 40 00],CAL.TAGON');
%FLIGHT.IMAGE1_cue = etime(DEPLOY.FLIGHT.IMAGE1,DEPLOY.TAGON.TIME);
%FLIGHT.IMAGE2_cue = etime(DEPLOY.FLIGHT.IMAGE2,DEPLOY.TAGON.TIME);
FLIGHT.DOWN_cue = etime([2016 2 17 17 43 00],CAL.TAGON');
TAGOFF_cue = etime(CAL.TAGOFF,CAL.TAGON');

% create time vector
t = (1:length(p))/fs;

%%
figure(1); clf
set(gcf,'position',[5 62 1595 756])
plot(t/(60*60),-p,'k') % plot depth

patch([FLIGHT.UP_cue/(60*60) FLIGHT.UP_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-20 20 20 -20],'k','FaceAlpha',0.25)
patch([FLIGHT.OVER_cue/(60*60) FLIGHT.OVER_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-20 20 20 -20],'r','FaceAlpha',0.5)
%plot([FLIGHT.IMAGE1_cue/(60*60) FLIGHT.IMAGE1_cue/(60*60)],[-60 20],'b--','LineWidth',2)
%plot([FLIGHT.IMAGE2_cue/(60*60) FLIGHT.IMAGE2_cue/(60*60)],[-60 20],'b--','LineWidth',2)

% ylim([-20 10]); 
xlim([0 TAGOFF_cue/(60*60)])
ylabel('Depth (m)'); xlabel('Time since tag on (hours)')

%% load UAS data
UAS = load('16021700_UASdata.mat'); % data exported from MKtool, time vector saved in excel from CSV and added to overall file
% correct for GMT2LOC
UAS.timevec(:,4) = UAS.timevec(:,4)-CAL.GMT2LOC;

%%
figure(2); clf; hold on
plot(datenum(UAS.timevec(:,1:6)),UAS.Altitudem)

for i = 1:length(UAS.timevec)
    UAS_cue(:,i) = etime(UAS.timevec(i,1:6),CAL.TAGON');
end
% add milliseconds
UAS_cue = UAS_cue + 0.1*UAS.timevec(:,7)';

%% add to Figure 1
figure(1); hold on
plot(UAS_cue/(60*60),UAS.Altitudem)

return

%%
cd C:\Users\Julie\Documents\MATLAB\UASDTAG
print('eg16_048a_UASdiveplot','-dpdf')