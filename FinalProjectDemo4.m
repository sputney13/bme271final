%% BME 271 Final Project Demo 4
%% Load Song, plot in Time Domain:
[audio, FS] = audioread('MHALL.mp3');
audio = sum(audio,2)/size(audio,2);
t = linspace(0,length(audio)/FS, length(audio));
    
figure(1); clf;
plot(t, audio, 'k-');
xlabel('Time (s)')
ylabel('Magnitude of Signal')
title('Time Domain Audio Recording')
%% Divide audio/time data into bins, fft, plot
X         = audio;
WINDOW    = hamming(2560);
NOVERLAP  = 2500;
NFFT      = 2560;

% Spectrogram:
[S,F,T,P] = spectrogram(X,WINDOW,NOVERLAP,NFFT,FS);
    
% Calculate Power/Frequency (dB/Hz):
PdBHz = 20*log10(abs(P));

% Plot Spectrogram Outputs:
figure(2); clf;
imagesc(T,F/1e3,PdBHz);
ax = gca;
ax.YDir = 'normal';
axis([0 22 0 3])
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Frequency (kHz)', 'FontSize', 12, 'FontWeight', 'bold');
c = colorbar;
colormap;
c.Label.String = 'Power/Frequency (dB/Hz)';
title('Spectrogram of Mary Had a Little Lamb');
%% Determine notes, plot onto staff
% creates musical "staff" for 3 notes
figure(3); clf
title('Sheet Music for Mary Had a Little Lamb')
for l = 1:3
    figure(3)
    plot(linspace(0,25,200), l*ones(200), 'k-')
    axis([0 25 0 4])
    hold on
end

% Set up quarter notes at which to measure frequency
quarternotes = zeros(1,32);
    for h = 1:32
        quarternotes(h) = T(ceil((h/32)*length(T))-...
            floor((1/32)*length(T)));
    end
    
% identify notes based on power, time, frequency
for iter = 1:length(quarternotes)
    for freq = 1:length(F)
        time = find(T == quarternotes(iter));
           if PdBHz(freq,time) > -135 && F(freq) < .26e3
               figure(3)
               plot(quarternotes(iter), 1, 'r*')
               hold on
           elseif PdBHz(freq,time) > -100 && F(freq) >= .29e3 &&...
                   F(freq) <= .30e3
               figure(3)
               plot(quarternotes(iter), 2, 'r*')
               hold on
           elseif PdBHz(freq,time) > -100 && F(freq) >= .34e3...
                   && F(freq) <= .38e3
               figure(3)
               plot(quarternotes(iter), 3, 'r*')
               hold on
           end
    end
end
%% Plot MHALL on same staff for comparison
figure(3)
hold on
quartert = linspace(1.5, max(T)+.5, 32);
notes = [3,2,1,2,3,3,3,3,2,2,2,2,3,3,3,3,3,2,1,2,3,3,3,1,2,2,3,2,1,1,1,1];
plot(quartert, notes, 'b-')
print -dpdf MHALLSpectogram