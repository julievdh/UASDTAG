% Chile Blue Whales
% Hexacopter dive profile plot

% set up presets
path = 'F:\bm15\bm15_053a\';
settagpath('cal',[path 'cal\'],'prh',[path 'prh\'],'raw',[path 'raw\'],'audit',[path 'audit\'])
settagpath('audio','F:\')
tag = 'bm15_053a';

% load data and cal/deploy information
loadprh(tag)
[CAL,DEPLOY] = d3loadcal(tag);

% Calculate time cues
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
%plot([FLIGHT.IMAGE1_cue/(60*60) FLIGHT.IMAGE1_cue/(60*60)],[-60 20],'b--','LineWidth',2)
%plot([FLIGHT.IMAGE2_cue/(60*60) FLIGHT.IMAGE2_cue/(60*60)],[-60 20],'b--','LineWidth',2)

ylim([-60 20])
ylabel('Depth (m)'); xlabel('Time since tag on (hours)')

% zoomed in
subplot('position',[0.1 0.1 0.85 0.35]); hold on
plot(t([(FLIGHT.UP_cue-40)*fs:(FLIGHT.DOWN_cue+40)*fs])/60,-p((FLIGHT.UP_cue-40)*fs:(FLIGHT.DOWN_cue+40)*fs),'k')

plot([FLIGHT.UP_cue/60 FLIGHT.UP_cue/60],[-20 5],'k','LineWidth',2)
plot([FLIGHT.OVER_cue/60 FLIGHT.OVER_cue/60],[-20 5],'k','LineWidth',2)
plot([FLIGHT.DOWN_cue/60 FLIGHT.DOWN_cue/60],[-20 5],'k','LineWidth',2)
%plot([FLIGHT.IMAGE1_cue/60 FLIGHT.IMAGE1_cue/60],[-20 5],'b--','LineWidth',2)
%plot([FLIGHT.IMAGE2_cue/60 FLIGHT.IMAGE2_cue/60],[-20 5],'b--','LineWidth',2)

xlabel('Time since tag on (min)'); ylabel('Depth (m)')
adjustfigurefont
xlim([3689/60 4728/60])

print('DiveProf_053a','-dtiff','-r300')
