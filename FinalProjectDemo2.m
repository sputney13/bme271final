%% BME 271 Final Project Demo 2
%% Open audiofile
% Reads in audiofile, combines audio data into a single vector
[audiob, FSb] = audioread('Dont Let Me Down.m4a');
song = sum(audiob,2)/size(audiob,2);
[audios, FSs] = audioread('Chromatic Scale.mp3');
cscale = sum(audios,2)/size(audios,2);
%% Clip audiofile background, clip scale into notes
% Extracts audio data for the background, notes of the scale
background = song(.1*FSb:6*FSb);
tbackground = (.1:1/FSb:6);
tnote = 0:1/FSs:.4;

fsharp = cscale(4.8*FSs:5.2*FSs);
g = cscale(5.4*FSs:5.8*FSs);
gsharp = cscale(5.9*FSs:6.3*FSs);
a = cscale(6.4*FSs:6.8*FSs);
asharp = cscale(6.9*FSs:7.3*FSs);
b = cscale(7.4*FSs:7.8*FSs);
c = cscale(8*FSs:8.4*FSs);
csharp = cscale(8.5*FSs:8.9*FSs);
d = cscale(9*FSs:9.4*FSs);
dsharp = cscale(9.5*FSs:9.9*FSs);
e = cscale(10.1*FSs:10.5*FSs);
f = cscale(10.6*FSs:11*FSs);
%% Correlates note with background music to determine presence
% Plots background music
figure(1); clf
plot(tbackground, background, 'k-')
title("Plot of Background Music")

% Sets up 12 notes in chromatic scale as a matrix
chromscale = [fsharp, g, gsharp, a, asharp, b, c, csharp, d, dsharp, e, f];

% Creates 12 note "sheet music"
figure(14); clf
for l = 1:12
    figure(14)
    plot(linspace(0,7,100), l*ones(100), 'k-')
    hold on
end

% iterates through 12 notes to convolve each with background music
for n = 1:12
    flipnote = fliplr(chromscale(:,n));
    correlate = conv(flipnote, background);
    tcorrelate = linspace(0,length(correlate)/FSb,length(correlate));
    figure(n+1); clf
    plot(tcorrelate, correlate, 'k-')
    
    % only notes at the eighth notes in the song
    eighthnotes = zeros(1,32);
    for h = 1:32
        eighthnotes(h) = tcorrelate(ceil((h/32)*length(tcorrelate))-...
            floor((1/32)*length(tcorrelate)));
    end
    
    % if the correlation is higher than a threshold plot
    for iter = 1:length(eighthnotes)
        time = find(tcorrelate == eighthnotes(iter));
        if correlate(time) > .35*max(correlate)
            figure(14)
            plot(eighthnotes(iter), n, 'r*')
            hold on
        end
    end
end
%% Plot actual music on top of correlation
figure(14)
title("Sheet Music for Background of Don't Let Me Down (Correlation)")
hold on
eighthtime = linspace(0, max(tcorrelate), 32);
notes = [3,3,3,3,3,1,1,1,10,10,10,10,10,10,10,10,5,5,5,5,5,5,5,...
    5,5,6,6,6,6,6,5,5];
plot(eighthtime, notes, 'b--')
print -dpdf DLMDCorrelate