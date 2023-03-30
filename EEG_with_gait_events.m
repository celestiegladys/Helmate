% Load gait event timestamps (replace with your own data)
load("event_location.mat")

% Define the event type for gait events
event_type = 'heel_strike';

% Define the event latency for gait events (in samples, relative to start of EEG data)
event_latency = 0;

% Convert gait event times to EEG event samples
event_samples = round(event_location * EEG.srate);

% Create EEGLAB event structure
events = struct(...
    'type', repmat({event_type}, size(event_samples)),...
    'latency', num2cell(event_samples + event_latency),...
    'urevent', num2cell(1:numel(event_samples))...
);

% Save events as an event file
pop_editeventvals(EEG, 'changefield', {1 'event' events});
pop_saveset(EEG, 'filename', 'EEG_with_gait_events.set', 'filepath', 'C:\Users\jetslab\Desktop\Helmate');
