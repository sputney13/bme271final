%% BME 271 Final Project Demo 1
%% Open audiofile
% Reads in audiofile, combines audio data into a single vector
[audio, FS] = audioread('Dont Let Me Down.m4a');
song = sum(audio,2)/size(audio,2);
%% Clip audiofile to chorus, background music
% Extracts audio data for the 36 second chorus and the 5.9s repeating
% background beat (repeats throughout song except for beat drops
chorus = song(36*FS:72*FS);
background = song(.1*FS:6*FS);
%% Plot and play chorus clip, background
% Time vectors for the chorus and the background music clips
tchorus = (0:(1/FS):36)';
tbackground = (.1:(1/FS):6)';
% Plots chorus clip
figure(1); clf
subplot(3,1,1)
plot(tchorus,chorus,'k-') 
xlabel('Time (s)')
ylabel('Audio Data')
title("Audio Data for Chorus of Don't Let Me Down")
hold on
% plots background clip
subplot(3,1,2)
plot(tbackground,background,'k-')
axis([0 36 -2 2])
xlabel('Time (s)')
ylabel('Audio Data')
title("Audio Data for Background Music of Don't Let Me Down")
% Optional: plays the clips
% soundsc(background, FS)
soundsc(chorus,FS)
%% Correlate background clip with chorus, plot
% Time vector for the correlation of the background with the chorus
tstart = tchorus(1) - tbackground(end);
tend = tchorus(end) - tbackground(1);
tcorrelate = tstart:1/FS:tend;
% Correlates the background with the chorus by flipping then convolving
FlipBack = fliplr(background);
Correlation = conv(FlipBack, chorus);
% Plots the correlation
subplot(3,1,3)
plot(tcorrelate, Correlation, 'k-')
title('Correlation of Background with Chorus')
hold on
%% Background Detector
% Iterates through correlation data searching for a threshold of 50% of the
% max value. If this is found, plots a red star at the point on both the
% correlation plot then iterates forward the length of
% the background music to prevent double-counting.
i = 1;
NumBackgrounds = 0;
while i <= length(tcorrelate)
    if Correlation(i) > 250
        subplot(3,1,3)
        plot(tcorrelate(i), 499, 'r*')
        i = i + 5.9*FS;
        NumBackgrounds = NumBackgrounds + 1;
    else
        i = i + 1;
    end
end
NumBackgrounds