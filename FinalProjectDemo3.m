%% BME 271 Final Project Demo 3
%% Open audiofile
% Reads in audiofile, combines audio data into a single vector
[audiob, FSm] = audioread('MHALL.mp3');
MHALL = sum(audiob,2)/size(audiob,2);
soundsc(MHALL, FSm)
[audios, FSs] = audioread('Chromatic Scale.mp3');
cscale = sum(audios,2)/size(audios,2);
%% Clip audiofile background, clip scale into notes
% Extracts audio data for the background, notes of the scale
tMHALL = (0:1/FSm:(length(MHALL)-1)/FSm);
tnote = 0:1/FSs:.4;

c = cscale(8*FSs:8.4*FSs);
d = cscale(9*FSs:9.4*FSs);
e = cscale(10.1*FSs:10.5*FSs);
%% Correlates note with background music to determine presence
% Plot audio
figure(1); clf
plot(tMHALL, MHALL, 'k-')
title('Plot of Audio in Mary Had a Little Lamb')

% 3 notes needed to recreate audio
chromscale = [c,d,e];

% creates musical "staff" for 3 notes
figure(5); clf
title('Sheet Music for Mary Had a Little Lamb')
for l = 1:3
    figure(5)
    plot(linspace(0,25,200), l*ones(200), 'k-')
    axis([0 25 0 4])
    hold on
end

% correlates three notes with song
for n = 1:3
    flipnote = fliplr(chromscale(:,n));
    correlate = conv(flipnote, MHALL);
    tcorrelate = linspace(0,length(correlate)/FSm,length(correlate));
    figure(n+1); clf
    plot(tcorrelate, correlate, 'k-')
    
    iter = 1;
    while iter <= length(tcorrelate)
        if correlate(iter) > .6*max(correlate)
            figure(5)
            plot((tcorrelate(iter)-1), n, 'r*')
            hold on
            iter = iter + .5*FSm;
        else
            iter = iter + 1000;
        end
    end
end
%% Plot MHALL on same staff for comparison
figure(5)
hold on
quartert = linspace(.5, max(tcorrelate), 32);
notes = [3,2,1,2,3,3,3,3,2,2,2,2,3,3,3,3,3,2,1,2,3,3,3,1,2,2,3,2,1,1,1,1];
plot(quartert, notes, 'b-')
print -dpdf MHALLCorrelation