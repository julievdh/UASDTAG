% dive comparison

warning off

% find dives
T = finddives(p,fs,5);

% time vector
t = (1:length(p))/fs;

% plot dives
figure(1); clf; hold on
plot(t,-p)
plot(T(:,1),zeros(length(T),1),'r.')

% choose 10 dives 1 hr later
after = find(T(:,1) > (FLIGHT.DOWN_cue + 60*60));
after = after(1:10);
plot(T(after,1),zeros(10,1),'g.')

% figure normalized duration
figure(9); clf
for i = 1:length(after)
    ind = after(i);
    [dstart,dend,ntime] = NormalizedDive(T(ind,:),p,fs,1,9);
end

% find the one where the drone was overhead
APHind = find(T(:,1) > FLIGHT.UP_cue & T(:,1) < FLIGHT.DOWN_cue);
figure(1); plot(T(APHind,1),zeros(length(APHind),1),'ko')

if isempty(strfind(tag,'053')) % if it's NOT tag 053
    [dstart1,dend1,ntime1] = NormalizedDive(T(1,:),p,fs,2,10);
    [dstart2,dend2,ntime2] = NormalizedDive(T(2,:),p,fs,2,10);
    
    figure(9);
    plot(ntime1,-p(fs*dstart1:fs*dend1),'r','LineWidth',2)
    plot(ntime2,-p(fs*dstart2:fs*dend2),'r','LineWidth',2)
else
    [dstart8,dend8,ntime8] = NormalizedDive(T(8,:),p,fs,2,10);
    [dstart9,dend9,ntime9] = NormalizedDive(T(9,:),p,fs,2,10);
    figure(9);
    plot(ntime8,-p(fs*dstart8:fs*dend8),'r','LineWidth',2)
    plot(ntime9,-p(fs*dstart9:fs*dend9),'r','LineWidth',2)
end

title(strcat('vs. 1 Hr After;',regexprep(tag,'_',' ')))
xlabel('Normalized Duration'); ylabel('Depth (m)')
adjustfigurefont
% save figure
fname = strcat(tag,'_1hrAfterUAS');
print(fname,'-dtiff','-r300')

%% find dives before
% ONLY IF TAG 053a
if isempty(strfind(tag,'054')) 
before = find(T(:,1) < (FLIGHT.UP_cue));
figure(1); plot(T(before,1),zeros(length(before),1),'y.')

% figure normalized duration
figure(8); clf; hold on
for i = 1:length(before)
    ind = before(i);
    [dstart,dend,ntime] = NormalizedDive(T(ind,:),p,fs,1,8);
end

% find dives where APH overhead
figure(8);
if isempty(strfind(tag,'053')) % if it's NOT tag 053
    plot(ntime1,-p(fs*dstart1:fs*dend1),'r','LineWidth',2)
    plot(ntime2,-p(fs*dstart2:fs*dend2),'r','LineWidth',2)
else
    plot(ntime8,-p(fs*dstart8:fs*dend8),'r','LineWidth',2)
    plot(ntime9,-p(fs*dstart9:fs*dend9),'r','LineWidth',2)
end

title(strcat('vs. Immediately Before;',regexprep(tag,'_',' ')))
xlabel('Normalized Duration'); ylabel('Depth (m)')
adjustfigurefont

% save figure
fname = strcat(tag,'_beforeUAS');
print(fname,'-dtiff','-r300')

end

%% compare with dives immediately after
after = find(T(:,1) > (FLIGHT.DOWN_cue));
after = after(1:10);
figure(1); plot(T(after,1),zeros(10,1),'g.')

% figure normalized duration
figure(10); clf
for i = 1:length(after)
    ind = after(i);
    [dstart,dend,ntime] = NormalizedDive(T(ind,:),p,fs,1,10);
end

% find the one where the drone was overhead
if isempty(strfind(tag,'053')) % if it's NOT tag 053
    plot(ntime1,-p(fs*dstart1:fs*dend1),'r','LineWidth',2)
    plot(ntime2,-p(fs*dstart2:fs*dend2),'r','LineWidth',2)
else
    plot(ntime8,-p(fs*dstart8:fs*dend8),'r','LineWidth',2)
    plot(ntime9,-p(fs*dstart9:fs*dend9),'r','LineWidth',2)
end

title(strcat('vs. Immediately After;',regexprep(tag,'_',' ')))
xlabel('Normalized Duration'); ylabel('Depth (m)')
adjustfigurefont

% save figure
fname = strcat(tag,'_AfterUAS');
print(fname,'-dtiff','-r300')