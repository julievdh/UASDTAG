% Chile Blue Whales
% Hexacopter dive profile plot

% set up presets
path = 'F:\bm15\bm15_054a\';
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

%% plot
figure(10); clf
set(gcf,'position',[5 62 1595 756])
subplot('position',[0.1 0.55 0.85 0.4]); hold on
plot(t/(60*60),-p,'k') % plot depth

patch([FLIGHT.UP_cue/(60*60) FLIGHT.UP_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'k','FaceAlpha',0.25)
patch([FLIGHT.OVER_cue/(60*60) FLIGHT.OVER_cue/(60*60) FLIGHT.DOWN_cue/(60*60) FLIGHT.DOWN_cue/(60*60)],[-120 10 10 -120],'r','FaceAlpha',0.5)

ylim([-120 10]); xlim([-0.5 37282/(60*60)]) 
ylabel('Depth (m)'); xlabel('Time since tag on (hours)')

% zoomed in
subplot('position',[0.1 0.1 0.85 0.35]); hold on
plot(t(1:(FLIGHT.DOWN_cue+40)*fs)/(60),-p(1:(FLIGHT.DOWN_cue+40)*fs),'k')

plot([FLIGHT.UP_cue/60 FLIGHT.UP_cue/60],[-35 5],'k','LineWidth',2)
plot([FLIGHT.OVER_cue/60 FLIGHT.OVER_cue/60],[-35 5],'k','LineWidth',2)
plot([FLIGHT.DOWN_cue/60 FLIGHT.DOWN_cue/60],[-35 5],'k','LineWidth',2)

xlabel('Time since tag on (min)')
ylabel('Depth (m)')
adjustfigurefont
xlim([0 14])

print('DiveProf_054a','-dtiff','-r300')