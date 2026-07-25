clear
clc
close all

%% Signal Parameters

Fs = 1000;
T = 1/Fs;
duration = 1;

t = 0:T:duration-T;

%% Signal Selection

signalChoice = menu( ...
    'Choose a Signal', ...
    'Sine Wave', ...
    'Cosine Wave', ...
    'Square Wave', ...
    'Sawtooth Wave', ...
    'Triangle Wave');

A = input('Amplitude = ');
f = input('Frequency (Hz) = ');

switch signalChoice

    case 1
        x = A*sin(2*pi*f*t);

    case 2
        x = A*cos(2*pi*f*t);

    case 3
        x = A*square(2*pi*f*t);

    case 4
        x = A*sawtooth(2*pi*f*t);

    case 5
        x = A*sawtooth(2*pi*f*t, 0.5);

    otherwise
        error('No signal was selected.')
end

%% Original Signal Frequency Analysis

N = length(x);

X = fft(x);

P2 = abs(X/N);

P1 = P2(1:floor(N/2)+1);

P1(2:end-1) = 2*P1(2:end-1);

frequencyAxis = Fs*(0:floor(N/2))/N;

%% Add White Gaussian Noise

addNoise = menu( ...
    'Add Noise?', ...
    'No', ...
    'Yes');

if addNoise == 2

    SNR = input('Signal-to-Noise Ratio (dB) = ');

    signalPower = mean(x.^2);

    noisePower = signalPower/(10^(SNR/10));

    noise = sqrt(noisePower)*randn(size(x));

    noisySignal = x + noise;

else

    noisySignal = x;

end

%% Noisy Signal Frequency Analysis

X_noisy = fft(noisySignal);

P2_noisy = abs(X_noisy/N);

P1_noisy = P2_noisy(1:floor(N/2)+1);

P1_noisy(2:end-1) = 2*P1_noisy(2:end-1);

%% Filter Selection

filterChoice = menu( ...
    'Choose a Filter', ...
    'No Filter', ...
    'Low-Pass Filter', ...
    'High-Pass Filter', ...
    'Band-Pass Filter');

switch filterChoice

    case 1
        filteredSignal = noisySignal;
        filterDescription = 'No Filter';

    case 2
        cutoffFrequency = ...
            input('Low-pass cutoff frequency (Hz) = ');

        validateattributes( ...
            cutoffFrequency, ...
            {'numeric'}, ...
            {'scalar','positive','<',Fs/2});

        [b, a] = butter( ...
            4, ...
            cutoffFrequency/(Fs/2), ...
            'low');

        filteredSignal = filtfilt(b, a, noisySignal);

        filterDescription = sprintf( ...
            'Low-Pass Filter, Fc = %.1f Hz', ...
            cutoffFrequency);

    case 3
        cutoffFrequency = ...
            input('High-pass cutoff frequency (Hz) = ');

        validateattributes( ...
            cutoffFrequency, ...
            {'numeric'}, ...
            {'scalar','positive','<',Fs/2});

        [b, a] = butter( ...
            4, ...
            cutoffFrequency/(Fs/2), ...
            'high');

        filteredSignal = filtfilt(b, a, noisySignal);

        filterDescription = sprintf( ...
            'High-Pass Filter, Fc = %.1f Hz', ...
            cutoffFrequency);

    case 4
        lowerCutoff = ...
            input('Lower cutoff frequency (Hz) = ');

        upperCutoff = ...
            input('Upper cutoff frequency (Hz) = ');

        if lowerCutoff <= 0 || ...
                upperCutoff >= Fs/2 || ...
                lowerCutoff >= upperCutoff

            error(['Cutoff frequencies must satisfy: ', ...
                '0 < lower cutoff < upper cutoff < Fs/2.'])
        end

        normalizedCutoffs = ...
            [lowerCutoff upperCutoff]/(Fs/2);

        [b, a] = butter( ...
            4, ...
            normalizedCutoffs, ...
            'bandpass');

        filteredSignal = filtfilt(b, a, noisySignal);

        filterDescription = sprintf( ...
            'Band-Pass Filter, %.1f-%.1f Hz', ...
            lowerCutoff, ...
            upperCutoff);

    otherwise
        error('No valid filter option was selected.')
end

%% Filtered Signal Frequency Analysis

X_filtered = fft(filteredSignal);

P2_filtered = abs(X_filtered/N);

P1_filtered = ...
    P2_filtered(1:floor(N/2)+1);

P1_filtered(2:end-1) = ...
    2*P1_filtered(2:end-1);

%% Signal Explorer Dashboard

figure('Position', [100 100 1200 850])

tiledlayout( ...
    3, ...
    2, ...
    'TileSpacing', 'compact', ...
    'Padding', 'compact')

nexttile
plot(t, x, 'LineWidth', 1.5)
grid on
title('Original Signal')
xlabel('Time (s)')
ylabel('Amplitude')

nexttile
plot(frequencyAxis, P1, 'LineWidth', 1.5)
grid on
title('Original Spectrum')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

nexttile
plot(t, noisySignal, 'LineWidth', 1.2)
grid on
title('Noisy Signal')
xlabel('Time (s)')
ylabel('Amplitude')

nexttile
plot( ...
    frequencyAxis, ...
    P1_noisy, ...
    'LineWidth', 1.2)

grid on
title('Noisy Spectrum')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

nexttile
plot(t, filteredSignal, 'LineWidth', 1.5)
grid on
title('Filtered Signal')
xlabel('Time (s)')
ylabel('Amplitude')

nexttile
plot( ...
    frequencyAxis, ...
    P1_filtered, ...
    'LineWidth', 1.5)

grid on
title('Filtered Spectrum')
xlabel('Frequency (Hz)')
ylabel('Magnitude')

sgtitle({ ...
    'Interactive Signal Explorer', ...
    filterDescription})

%% Save Dashboard

exportgraphics( ...
    gcf, ...
    'signal_explorer_dashboard.png', ...
    'Resolution', 300)

%% Aliasing Demonstration

aliasChoice = menu( ...
    'Show Sampling and Aliasing Demonstration?', ...
    'No', ...
    'Yes');

if aliasChoice == 0
    disp('Aliasing demonstration cancelled.')

elseif aliasChoice == 2

    aliasFs = input('New sampling frequency (Hz) = ');

    validateattributes( ...
        aliasFs, ...
        {'numeric'}, ...
        {'scalar', 'positive', 'finite'});

    aliasT = 1/aliasFs;
    aliasTime = 0:aliasT:duration-aliasT;

    switch signalChoice

        case 1
            aliasSignal = A*sin(2*pi*f*aliasTime);
            signalName = 'Sine Wave';

        case 2
            aliasSignal = A*cos(2*pi*f*aliasTime);
            signalName = 'Cosine Wave';

        case 3
            aliasSignal = A*square(2*pi*f*aliasTime);
            signalName = 'Square Wave';

        case 4
            aliasSignal = A*sawtooth(2*pi*f*aliasTime);
            signalName = 'Sawtooth Wave';

        case 5
            aliasSignal = A*sawtooth( ...
                2*pi*f*aliasTime, ...
                0.5);

            signalName = 'Triangle Wave';

    end

end
%% Sampling and Aliasing Visualization

if aliasChoice == 2

    figure('Position', [200 100 1000 600])

    plot(t, x, 'LineWidth', 1.5)
    hold on

    stem( ...
        aliasTime, ...
        aliasSignal, ...
        'filled', ...
        'LineWidth', 1.1)

    grid on

    xlabel('Time (s)')
    ylabel('Amplitude')

    title(sprintf( ...
        '%s Sampling Demonstration', ...
        signalName))

    legend( ...
        sprintf('Reference signal, Fs = %.0f Hz', Fs), ...
        sprintf('Samples, Fs = %.0f Hz', aliasFs), ...
        'Location', 'best')

    xlim([0 min(duration, 5/f)])

end

%% Nyquist Check

if aliasChoice == 2

    nyquistRate = 2*f;

    fprintf('\n--- Sampling Analysis ---\n')
    fprintf('Signal frequency: %.2f Hz\n', f)
    fprintf('Sampling frequency: %.2f Hz\n', aliasFs)
    fprintf('Minimum Nyquist rate: %.2f Hz\n', nyquistRate)

    if aliasFs >= nyquistRate

        fprintf('Nyquist criterion satisfied.\n')
        fprintf('The fundamental frequency should not alias.\n')

    else

        fprintf('Nyquist criterion violated.\n')
        fprintf('Aliasing is expected.\n')

        aliasFrequency = abs( ...
            f - round(f/aliasFs)*aliasFs);

        fprintf( ...
            'Apparent aliased frequency: %.2f Hz\n', ...
            aliasFrequency)

    end

end