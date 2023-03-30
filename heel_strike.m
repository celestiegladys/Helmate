% Load the accleration data
data_accleration= transpose(data{1, 2}.time_series(:,500:1500));
data_accleration2=(data_accleration)-[1004,-4, -76];

% Select the z-axis accleration data
acc_z = data_accleration2(:,3);
% Set the sampling frequency
fs = 99;

% Apply a low-pass filter 
fc_low = 5; % Low-pass cutoff frequency (Hz)
[b_low,a_low] = fir1(80, fc_low/(fs/2), 'low'); % Butterworth low-pass filter design
lowpass_acc = filtfilt(b_low, a_low, double(data_accleration2)); % Apply filter

% Apply a high-pass filter
fc = 1; % Cutoff frequency (Hz)
[b,a] = fir1(80, fc/(fs/2), 'high');%high-pass filter design
filtered_acc = filtfilt(b, a, double(lowpass_acc)); % Apply filter
filtered_acc_z = filtered_acc(:,3);

% threshold value for peak detection
threshold = 0.2 * max(filtered_acc_z);

% Find the peaks in the filtered acceleration signal
[peaks, peak_locations] = findpeaks(filtered_acc_z, 'MinPeakHeight', threshold);

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


% Print the heel strike locations
disp(heel_strike_locations);



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
    if mod(i,2)==1
    xline(heel_strike_locations(i),'r--','LineWidth',1.5);
    else
    xline(heel_strike_locations(i),'g--','LineWidth',1.5); 
    end 
end


% Plot the filtered acceleration signal with detected peaks
figure;
plot(acc_z);
hold on;
%plot(heel_strike_locations, filtered_acc_z(heel_strike_locations), 'r*');
xlabel('Sample');
ylabel('Acceleration');
title('raw acceleration signal with detected peaks');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    if mod(i,2)==1
    xline(heel_strike_locations(i),'r--','LineWidth',1.5);
    else
    xline(heel_strike_locations(i),'g--','LineWidth',1.5); 
    end 
end

% Plot the filtered acceleration signal with detected peaks
figure;
plot(acc_z);
hold on;
plot( filtered_acc_z);
xlabel('Sample');
ylabel('Acceleration');
title('raw acceleration signal with detected peaks');

% Mark the heel strikes as red circles on the plot
for i = 1:length(heel_strike_locations)
    if mod(i,2)==1
    xline(heel_strike_locations(i),'r--','LineWidth',1.5);
    else
    xline(heel_strike_locations(i),'g--','LineWidth',1.5); 
    end 
end