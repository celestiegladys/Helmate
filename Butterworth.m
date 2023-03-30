% Apply a low-pass filter to remove high-frequency noise
fc_low = 1; % Low-pass cutoff frequency (Hz)
[b_low,a_low] = butter(2, fc_low/(99/2), 'low'); % Butterworth low-pass filter design
lowpass_data = filtfilt(b_low, a_low, double(EEG.data)); % Apply filter
