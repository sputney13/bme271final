%% BME 271 Final Project Demo 5
%% Load Song, plot in Time Domain:
[audio, FS] = audioread('Dont Let Me Down.m4a');
audio = sum(audio,2)/size(audio,2);
background = audio(.1*FS:6*FS);
tbackground = (.1:(1/FS):6)';

figure(1); clf;
plot(tbackground, background, 'k-');
xlabel('Time (s)')
ylabel('Magnitude of Signal')
title('Time Domain Audio Recording')
%% Divide audio/time data into bins, fft, plot
X         = background;
WINDOW    = hamming(12000);
NOVERLAP  = 11000;
NFFT      = 12000;

% Spectrogram:
[S,F,T,P] = spectrogram(X,WINDOW,NOVERLAP,NFFT,FS);
    
% Calculate Power/Frequency (dB/Hz):
PdBHz = 20*log10(abs(P));

% Plot Spectrogram Outputs:
figure(2); clf;
imagesc(T,F/1e3,PdBHz);
ax = gca;
ax.YDir = 'normal';
axis([0 5.8 0 1])
xlabel('Time (s)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Frequency (kHz)', 'FontSize', 12, 'FontWeight', 'bold');
c = colorbar;
colormap;
c.Label.String = 'Power/Frequency (dB/Hz)';
title("Spectrogram of Don't Let Me Down");
%% Determine notes, plot onto staff
% creates musical "staff" for 3 notes
figure(3); clf
for l = 1:12
    figure(3)
    plot(linspace(0,7,100), l*ones(100), 'k-')
    hold on
end

% Set up quarter notes at which to measure frequency
eighthnotes = zeros(1,32);
    for h = 1:32
        eighthnotes(h) = T(ceil((h/32)*length(T))-...
            floor((1/32)*length(T)));
    end
    
% identify notes based on power, time, frequency
for iter = 1:length(eighthnotes)
    for freq = 1:length(F)
        time = find(T == eighthnotes(iter));
           if PdBHz(freq,time) > -60 && F(freq) >= .405e3 &&...
                   F(freq) <= .41e3
               figure(3)
               plot(eighthnotes(iter), 3, 'r*')
               hold on
           elseif PdBHz(freq,time) > -65 && F(freq) >= .36e3 &&...
                   F(freq) <= .37e3
               figure(3)
               plot(eighthnotes(iter), 1, 'r*')
               hold on
           elseif PdBHz(freq,time) > -75 && F(freq) >= .62e3...
                   && F(freq) <= .64e3
               figure(3)
               plot(eighthnotes(iter), 10, 'r*')
               hold on
           elseif PdBHz(freq,time) > -60 && F(freq) >= .46e3 &&...
                   F(freq) <= .47e3
               figure(3)
               plot(eighthnotes(iter), 5, 'r*')
               hold on
           elseif PdBHz(freq,time) > -75 && F(freq) >= .48e3 &&...
                   F(freq) <= .50e3
               figure(3)
               plot(eighthnotes(iter), 6, 'r*')
               hold on
           end
    end
end
%% Plot MHALL on same staff for comparison
figure(3)
title("Sheet Music for Background of Don't Let Me Down (Spectogram)")
hold on
eighthtime = linspace(.1, max(T)+.5, 32);
notes = [3,3,3,3,3,1,1,1,10,10,10,10,10,10,10,10,5,5,5,5,5,5,5,...
    5,5,6,6,6,6,6,5,5];
plot(eighthtime, notes, 'b--')
print -dpdf DLMDSpectogram