% Load the linear and angular acceleration data from the IMU
linear_acc = transpose(filtered_acc);  % Body frame acceleration
angular_acc=imu_rotation;  % Body frame angular acceleration

% Set the gravitational constant
g = 9.81;  % m/s^2

% Initialize the rotation matrix
R = eye(3);  % Identity matrix

% Initialize the orientation estimate using the identity matrix
% (i.e., assume that the IMU is initially aligned with the earth frame)
R_estimate = R;

% Set the sample time and number of samples
Ts = 0.01;  % sec
N = length(linear_acc);

% Pre-allocate the earth frame acceleration and gravity-compensated acceleration arrays
earth_frame_acc = zeros(3, N);
gravity_comp_acc = zeros(3, N);

% Loop over the samples and estimate the orientation, convert the body frame acceleration to
% the earth frame acceleration, and gravity compensate the acceleration
for k = 1:N
    % Update the orientation estimate using the angular velocity measurements
    R_dot = skew_sym(angular_acc(:, k)) * R_estimate;
    R_estimate = R_estimate + R_dot * Ts;
    
    % Convert the body frame acceleration to the earth frame acceleration
    earth_frame_acc(:, k) = R_estimate * linear_acc(:, k);
    
    % Gravity compensate the earth frame acceleration
    gravity_acc = -R_estimate(:, 3) * g;
    gravity_comp_acc(:, k) = earth_frame_acc(:, k) - gravity_acc;
end
disp(earth_frame_acc);
% Plot the earth frame acceleration and the gravity-compensated acceleration
subplot(2,1,1);
figure;
plot(t, earth_frame_acc);
xlabel('Time (sec)');
ylabel('Earth frame acceleration (m/s^2)');
legend('a_x', 'a_y', 'a_z');
subplot(2,1,2);
plot(t, gravity_comp_acc);
xlabel('Time (sec)');
ylabel('Gravity-compensated acceleration (m/s^2)');
legend('a_x', 'a_y', 'a_z');

% Helper function to compute the skew-symmetric matrix from a vector
function S = skew_sym(v)
    S = [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
end

