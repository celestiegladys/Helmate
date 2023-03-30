%eeg_helmate = pop_loadset('eeg_helmate.set', 'C:\Users\jetslab\Desktop\Helmate');
%data = eeg_helamte.set;
for i =event_location
    epoch_duration = i-(i+1);%calutlate the duration of each eapoch 
   % Create empty matrix to store the epochs
   num_epochs = length(event_location)-1;
   eeg_epochs = zeros(num_epochs,epoch_duration * 99);%considering the sampling frequency is 99hz 

   % Loop through each heel strike location and extract the corresponding epoch
   for x = 1:num_epochs
     % Determine the start and end times of the epoch based on the heel strike location
     epoch_start= eeg_data(i)-epoch_length/2 * 99;
     epoch_end = eeg_data(i+1) + epoch_length/2 * 99 - 1;
       % Make sure the epoch falls within the EEG data range
    if epoch_start > 0 && epoch_end <= eeg_data
        % Extract the EEG data for the epoch and store it in the eeg_epochs matrix
        eeg_epochs(x,:) = eeg_data(:, epoch_start:epoch_end);
    
    end
   end    
end    