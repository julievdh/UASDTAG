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
FLIGHT.UP_cue = etime(DEPLOY.FLIGHT.UP,DEPLOY.TAGON.TIME);
FLIGHT.OVER_cue = etime(DEPLOY.FLIGHT.OVER,DEPLOY.TAGON.TIME);
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

ylim([-60 5])
ylabel('Depth (m)')
set(gca,'ytick',[-60,-30,0],'yticklabel',{'60';'30';'0'})

%% plot 054

% set up presets
path = 'E:\bm15\bm15_054a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])
settagpath('audio','E:\')
tag = 'bm15_054a';

% load data and cal/deploy information
loadprh(tag)
[CAL,DEPLOY] = d3loadcal(tag);

% Calculate time cues
FLIGHT.UP_cue = etime(DEPLOY.FLIGHT.UP,DEPLOY.TAGON.TIME);
FLIGHT.OVER_cue = etime(DEPLOY.FLIGHT.OVER,DEPLOY.TAGON.TIME);
FLIGHT.DOWN_cue = etime(DEPLOY.FLIGHT.DOWN,DEPLOY.TAGON.TIME);

% create time vector
t = (1:length(p))/fs;

subplot('position',[0.1 0.1 0.85 0.4]); hold on
plot(t/(60*60),-p,'k') % plot depth

patch([FLIGHT.UP_cue/(60*60) FLIGHT.UP_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'k','FaceAlpha',0.25)
patch([FLIGHT.OVER_cue/(60*60) FLIGHT.OVER_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'r','FaceAlpha',0.5)

ylim([-120 10]); xlim([-0.5 37282/(60*60)]) 
ylabel('Depth (m)'); xlabel('Time since tag on (hours)')
set(gca,'ytick',[-120,-60,0],'yticklabel',{'120';'60';'0'})
adjustfigurefont

%%
print('DiveProf_both','-dtiff','-r300')
