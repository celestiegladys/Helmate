% Load EEG data
EEG = pop_loadset('eeg_helmate.set', 'C:\Users\jetslab\Desktop\Helmate');

% Define the positions of the events
heel_strike_position;

% Plot the EEG data with vertical lines indicating the event positions
figure;
plot(EEG.times, EEG.data(1,:), 'k');
hold on;
for i = 1:length(heel_strike_position)
    x = EEG.times(heel_strike_position(i));
    plot([x, x], ylim, 'r');
end
xlabel('Time (ms)');
ylabel('EEG signal');