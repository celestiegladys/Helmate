import numpy as np
import matplotlib.pyplot as plt
import scipy.io
from scipy.signal import butter, filtfilt, find_peaks

# Load data from a MATLAB .mat file
data = scipy.io.loadmat('data_acceleration')

# Load the acceleration data
data_acceleration = np.transpose(data[0][0]['time_series'])
data_acceleration2 = data_acceleration - [992, 80, -36]

# Select the z-axis acceleration data
acc_z = data_acceleration2[:, 2]

# Set the sampling frequency
fs = 99

# Apply a low-pass filter
fc_low = 5  # Low-pass cutoff frequency (Hz)
b_low, a_low = butter(4, fc_low/(fs/2), 'low')  # Butterworth low-pass filter design
lowpass_acc = filtfilt(b_low, a_low, np.double(data_acceleration2))  # Apply filter

# Apply a high-pass filter
fc = 1  # Cutoff frequency (Hz)
b, a = butter(1, fc/(fs/2), 'high')  # Butterworth high-pass filter design
filtered_acc = filtfilt(b, a, np.double(lowpass_acc))  # Apply filter
filtered_acc_z = filtered_acc[:, 2]

# Apply the RLF with a window size of 16 samples
window_size = 16
filtered_acc_z_rlf = np.zeros_like(filtered_acc_z)
for i in range(len(filtered_acc_z)-window_size+1):
    filtered_acc_z_rlf[i:i+window_size-1] = np.mean(filtered_acc_z[i:i+window_size-1])

# Set the threshold value for peak detection
threshold = 0.19 * np.max(filtered_acc_z_rlf)

# Find the peaks in the filtered acceleration signal
peaks, peak_locations = find_peaks(filtered_acc_z_rlf, height=threshold)

# Initialize variables for heel strike detection
heel_strike_locations = []
prev_heel_strike_location = 0

# Detect heel strikes by comparing the timing of the detected peaks to the
# previous heel strike location
for i in range(len(peak_locations)):
    if peak_locations[i] > prev_heel_strike_location:
        heel_strike_locations.append(peak_locations[i])
        prev_heel_strike_location = peak_locations[i]

# Print the heel strike locations
print(heel_strike_locations)

# Plot the filtered acceleration signal with detected peaks
fig, ax = plt.subplots()
ax.plot(filtered_acc_z)
ax.plot(heel_strike_locations, filtered_acc_z[heel_strike_locations], 'r*')
ax.set_xlabel('Sample')
ax.set_ylabel('Acceleration')
ax.set_title('Filtered acceleration signal with detected peaks')

# Mark the heel strikes as red circles on the plot
for loc in heel_strike_locations:
    ax.axvline(x=loc, color='r', linestyle='--', linewidth=1.5)

# Plot the original acceleration signal with detected peaks
fig, ax = plt.subplots()
ax.plot(filtered_acc)
ax.plot(heel_strike_locations, filtered_acc[heel_strike_locations], 'r*')
ax.set_xlabel('Sample')
ax.set_ylabel('Acceleration')
ax.set_title('Original acceleration signal with detected peaks')

# Mark the heel strikes as red circles on the plot
for loc in heel_strike_locations:
    ax.axvline(x=loc, color='r', linestyle='--', linewidth=1.5)

# Plot z-axis acceleration with time
#ig, ax = plt.subplots()
#ax.plot(EEG.times, filtered_acc_z)
#ax.plot(EEG.times[heel_strike_locations], filtered_acc_z[heel_strike_locations], 'r*')
#ax.set_xlabel('Time (s)')
#ax.set_ylabel('Z-Acceleration (m/s^
