% Load the accleration data
data_accleration= transpose(data{1, 2}.time_series);
data_accleration2=(data_accleration)-[1004,-4, -76];

% Select the z-axis accleration data
acc_z = data_accleration2(:,3);
% Set the sampling frequency
fs = 99;

% Apply a low-pass filter 
fc_low = 5; % Low-pass cutoff frequency (Hz)
[b_low,a_low] = butter(4, fc_low/(fs/2), 'low'); % Butterworth low-pass filter design
lowpass_acc = filtfilt(b_low, a_low, double(data_accleration2)); % Apply filter

% Apply a high-pass filter
fc = 1; % Cutoff frequency (Hz)
[b,a] = butter(1, fc/(fs/2), 'high'); % Butterworth high-pass filter design
filtered_acc = filtfilt(b, a, double(lowpass_acc)); % Apply filter
filtered_acc_z = filtered_acc(:,3);

% moving average filter to the z-axis acceleration data
window_size = 5; %  window size for the moving average filter
smoothed_acc_z = movmean(filtered_acc_z, window_size);


%  RLF with a window size of 16 samples
window_size = 16;
filtered_acc_z_rlf = zeros(size(filtered_acc_z));
for i = 1:length(filtered_acc_z)-window_size+1
    filtered_acc_z_rlf(i:i+window_size-1) = mean(filtered_acc_z(i:i+window_size-1));
end

% threshold value for peak detection
threshold = 0.17 * max(filtered_acc_z_rlf);
%threshold2 = 0.3 * max(smoothed_acc_z);
% Find the peaks in the filtered acceleration signal
[peaks, peak_locations] = findpeaks(filtered_acc_z_rlf, 'MinPeakHeight', threshold);

%  peaks in the smoothed acceleration signal
[peaks1, peak_locations1] = findpeaks(smoothed_acc_z, 'MinPeakHeight', threshold);


% Initialize variables for heel strike detection
heel_strike_locations = [];
prev_heel_strike_location = 0;

% Detect heel strikes by comparing the timing of the detected peaks to the
% previous heel strike location
for i = 1:length(peak_locations)
    if peak_locations(i) > prev_heel_strike_location
        heel_strike_locations(end+1) = peak_locations(i);
        prev_heel_strike_location = peak_locations(i);
    end
end
heel_strike_locations1 = [];
prev_heel_strike_location1 = 0;
% Detect heel strikes by comparing the timing of the detected peaks to the
% previous heel strike location
for i = 1:length(peak_locations1)
    if peak_locations1(i) > prev_heel_strike_location1
        heel_strike_locations1(end+1) = peak_locations1(i);
        prev_heel_strike_location1 = peak_locations1(i);
    end
end

% Print the heel strike locations
disp(heel_strike_locations);
disp(heel_strike_locations1);

% Plot the smoothed acceleration signal with detected peaks
figure;
plot(smoothed_acc_z);
hold on;
plot(heel_strike_locations1, smoothed_acc_z(heel_strike_locations1), 'r*');
xlabel('Sample');
ylabel('Acceleration');
title('Smoothed acceleration signal with detected peaks');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations1)
    xline(heel_strike_locations1(i),'r--','LineWidth',1.5);
end

% Plot the filtered acceleration signal with detected peaks
figure;
plot(filtered_acc_z);
hold on;
plot(heel_strike_locations, filtered_acc_z(heel_strike_locations), 'r*');
xlabel('Sample');
ylabel('Acceleration');
title('Filtered acceleration signal with detected peaks');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    xline(heel_strike_locations(i),'r--','LineWidth',1.5);
end

% Plot the original acceleration signal with detected peaks
figure;
plot(filtered_acc);
hold on;
plot(heel_strike_locations, filtered_acc(heel_strike_locations), 'r*');
xlabel('Sample');
ylabel('Acceleration ');
title('Original acceleration signal with detected peaks');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    xline(heel_strike_locations(i),'r--','LineWidth',1.5);
end

% Plot z-axis acceleration with time
figure;
plot(EEG.times, filtered_acc_z);
hold on;
plot(EEG.times(heel_strike_locations), filtered_acc_z(heel_strike_locations), 'r*');
xlabel('Time (s)');
ylabel('Z-Acceleration (m/s^2)');
title('Z-axis acceleration');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    xline(EEG.times(heel_strike_locations(i)), 'r--','LineWidth',1.5);
end

%plot eegdata with markers 
figure;
hold on;
plot(EEG.times, EEG.data(3,:));
plot(EEG.times(heel_strike_locations), filtered_acc_z(heel_strike_locations), 'r*');
xlabel('Time (s)');
ylabel('eegdata');
title('eeg_data');
% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    xline(EEG.times(heel_strike_locations(i)), 'r--','LineWidth',1.5);
end

