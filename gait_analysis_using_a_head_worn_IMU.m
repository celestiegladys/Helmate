function gait_analysis_using_a_head_worn_IMU(data_accleration, vel)
    NUM = 16;
    FILTER = 2;
    peak_counter_before_RLF = 0;
    peak_counter_after_RLF = 0;
    step_counter = 0;

    while true
        ACC_FT = fft(data_accleration);
        FILTER_ARRAY = zeros(size(data_accleration));
        FILTER_ARRAY(1:FILTER+1) = 1;
        FILTER_ARRAY(end-FILTER+1:end) = 1;
        ACC_TEMP = ACC_FT .* FILTER_ARRAY;
        acc_filtered = real(ifft(ACC_TEMP));
        heel_strike_finder(acc_filtered);
        toe_off_finder(data_acclerationdata_accleration, vel);
    end

    function heel_strike_finder(acc_filtered)
        [pks, locs] = findpeaks(acc_filtered);
        if ~isempty(pks) && peak_counter_after_RLF == 0
            step_counter = step_counter + 1;
            fprintf('Step %d\n', step_counter);
            peak_counter_after_RLF = 1;
            peak_counter_before_RLF = 0;
            fprintf('Heel strike time: %f\n', locs(1)/100); % Assuming acc is sampled at 60Hz
        elseif isempty(pks) && peak_counter_after_RLF == 1
            peak_counter_before_RLF = 0;
        end
    end

    function toe_off_finder(acc, vel)
        [pks_acc, locs_acc] = findpeaks(acc);
        [pks_vel, locs_vel] = findpeaks(-vel);
        if ~isempty(pks_acc)
            peak_counter_before_RLF = peak_counter_before_RLF + 1;
            if peak_counter_before_RLF == 3
                peak_counter_before_RLF = 0;
                fprintf('Toe off time: %f\n', locs_acc(1)/100); % Assuming acc is sampled at 60Hz
            end
        elseif ~isempty(pks_vel)
            peak_counter_before_RLF = 0;
            fprintf('Toe off time: %f\n', locs_vel(1)/100); % Assuming vel is sampled at 60Hz
        end
    end
end
