% Load the EEG signal and sampling rate
EEG.data;
Fs = 99;  % Sampling rate in Hz

% Define the window length and overlap for the spectrogram
win_len = ;  % Window length in samples
overlap = round(win_len * 0.75);  % Overlap length in samples

% Compute the spectrogram using a Hanning window and a fast Fourier transform
nfft = win_len;  % FFT length
window = hann(win_len);  % Hanning window taper
[S,F,T] = spectrogram(EEG.data, window, overlap, nfft, Fs);

% Plot the spectrogram
imagesc(T,F,abs(S));
axis xy;
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;