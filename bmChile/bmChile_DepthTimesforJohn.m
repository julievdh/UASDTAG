% Chile Blue Whales
% Hexacopter dive profile plot

% set up presets
path = 'F:\bm15\bm15_053a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])
settagpath('audio','E:\')
tag = 'bm15_053a';

% load data and cal/deploy information
loadprh(tag)
[CAL,DEPLOY] = d3loadcal(tag);

% Calculate time cues
% 2015-02-22 16-01-28
JOHN_cue = etime([2015 2 22 16 01 28],DEPLOY.TAGON.TIME);
FLIGHT.UP_cue = etime(DEPLOY.FLIGHT.UP,DEPLOY.TAGON.TIME);
FLIGHT.OVER_cue = etime(DEPLOY.FLIGHT.OVER,DEPLOY.TAGON.TIME);
FLIGHT.IMAGE1_cue = etime(DEPLOY.FLIGHT.IMAGE1,DEPLOY.TAGON.TIME);
FLIGHT.IMAGE2_cue = etime(DEPLOY.FLIGHT.IMAGE2,DEPLOY.TAGON.TIME);
FLIGHT.DOWN_cue = etime(DEPLOY.FLIGHT.DOWN,DEPLOY.TAGON.TIME);


% create time vector
t = (1:length(p))/fs;

%% plot
figure(10); clf
set(gcf,'position',[5 62 1595 756])
subplot('position',[0.1 0.55 0.85 0.4]); hold on
plot(t/(60*60),-p,'k') % plot depth

patch([FLIGHT.UP_cue/(60*60) FLIGHT.UP_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-60 20 20 -60],'k','FaceAlpha',0.25)
patch([FLIGHT.OVER_cue/(60*60) FLIGHT.OVER_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-60 20 20 -60],'r','FaceAlpha',0.5)
plot([JOHN_cue/(60*60) JOHN_cue/(60*60)],[-60 20],'k--','linewidth',2)

ylim([-60 5])
ylabel('Depth (m)')
set(gca,'ytick',[-60,-30,0],'yticklabel',{'60';'30';'0'})

cuedepth_053a = p(JOHN_cue)

%% plot 054

% set up presets
path = 'F:\bm15\bm15_054a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])
settagpath('audio','E:\')
tag = 'bm15_054a';

% load data and cal/deploy information
loadprh(tag)
[CAL,DEPLOY] = d3loadcal(tag);

% Calculate time cues
% 2015-02-23 19-05-28
JOHN_cue = etime([2015 2 23 19 05 28],DEPLOY.TAGON.TIME);
FLIGHT.UP_cue = etime(DEPLOY.FLIGHT.UP,DEPLOY.TAGON.TIME);
FLIGHT.OVER_cue = etime(DEPLOY.FLIGHT.OVER,DEPLOY.TAGON.TIME);
FLIGHT.DOWN_cue = etime(DEPLOY.FLIGHT.DOWN,DEPLOY.TAGON.TIME);

% create time vector
t = (1:length(p))/fs;

%%
subplot('position',[0.1 0.1 0.85 0.4]); hold on
plot(t/(60*60),-p,'k') % plot depth

patch([FLIGHT.UP_cue/(60*60) FLIGHT.UP_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'k','FaceAlpha',0.25)
patch([FLIGHT.OVER_cue/(60*60) FLIGHT.OVER_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'r','FaceAlpha',0.5)
plot([JOHN_cue/(60*60) JOHN_cue/(60*60)],[-120 10],'k--','linewidth',2)

ylim([-120 10]); xlim([-0.5 37282/(60*60)]) 
ylabel('Depth (m)'); xlabel('Time since tag on (hours)')
set(gca,'ytick',[-120,-60,0],'yticklabel',{'120';'60';'0'})
adjustfigurefont

cuedepth_054a = p(JOHN_cue)

%%
print('DiveProf_DepthTimes','-dtiff','-r300')
