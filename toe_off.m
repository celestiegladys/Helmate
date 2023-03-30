% Load the acceleration data
load('data_accleration');
load('heel_strike_locations');

% Select the z-axis acceleration data
acc_z = data_accleration(:,3);

% Set the sampling frequency
fs = 100; % Sampling frequency (Hz)

% Apply a low-pass filter to remove high-frequency noise
fc_low = 5; % Low-pass cutoff frequency (Hz)
[b_low,a_low] = butter(1, fc_low/(fs/2), 'low'); % Butterworth low-pass filter design
lowpass_acc = filtfilt(b_low, a_low, double(data_accleration)); % Apply filter

% Apply a high-pass filter to remove the DC component
fc = 1; % Cutoff frequency (Hz)
[b,a] = butter(1, fc/(fs/2), 'high'); % Butterworth high-pass filter design
filtered_acc = filtfilt(b, a, double(lowpass_acc)); % Apply filter
filtered_acc_z = filtered_acc(:,3); % Select the z-axis acceleration data

% Apply the RLF with a window size of 16 samples
window_size = 16;
filtered_acc_z_rlf = zeros(size(filtered_acc_z));
for i = 1:length(filtered_acc_z)-window_size+1
    filtered_acc_z_rlf(i:i+window_size-1) = mean(filtered_acc_z(i:i+window_size-1));
end

% Find the peaks in the filtered acceleration signal
threshold = 1;
[peaks, peak_locations] = findpeaks(filtered_acc_z_rlf, 'MinPeakHeight', threshold);

% Initialize arrays to store the TO and CT locations for each gait cycle
to_locations = zeros(1, length(heel_strike_locations)-1);

% Detect the TO and CT locations within each gait cycle
for i = 1:length(heel_strike_locations)-1
    % Determine the start and end indices of the current gait cycle
    cycle_start = heel_strike_locations(i);
    cycle_end = heel_strike_locations(i+1);

    % Find the peaks within the current gait cycle
    cycle_peaks = peaks(peak_locations > cycle_start & peak_locations < cycle_end);
    cycle_locations = peak_locations(peak_locations > cycle_start & peak_locations < cycle_end);
    
    % Detect the third peak as the TO and ignore the peak appearing in five frames after the HS
    if length(cycle_locations) >= 3
        to_location = cycle_locations(3) + cycle_start - 1;
        if length(cycle_locations) > 3 && cycle_locations(4) - cycle_locations(2) < 5
            hs_location = cycle_locations(1) + cycle_start - 1;
        else
            hs_location = cycle_locations(2) + cycle_start - 1;
        end
        % Store the TO and CT locations for the current gait cycle
         to_locations(i) = to_location;
    end      
end

