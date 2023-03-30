% Load the physionet toolbox
addpath('path/to/physionet')

% Specify the EDF file name and path
walking.edf = 'path/to/your/walking.edf';

% Read the EDF file using the physionet_read function
[header, data] = physionet_read(walking.edf);

% Extract the signal data from the data matrix
signal = data(:,1);

% Extract the sampling frequency from the header struct
fs = header.sample_rate(1);

% Create a time vector for the signal
t = (0:length(signal)-1)/fs;

% Plot the signal
plot(t, signal);
xlabel('Time (s)');
ylabel('Signal amplitude');