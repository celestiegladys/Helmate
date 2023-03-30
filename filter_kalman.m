% Define initial state estimate and error covariance
x0 = [1 0 0 0 0 0 0].';
P0 = eye(7);
dt=0.01;
% Define process noise covariance
Q = diag([0.01 0.01 0.01 0.01 0.01 0.01]);

% Define measurement noise covariance
R = diag([0.1 0.1 0.1 0.01 0.01 0.01]);

[orientation, angular_vel, ~] = kalman_filter(w, a, t, x0, P0, Q, R);
disp('Orientation quaternion:');
disp(orientation);
disp('Angular velocity:');
disp(angular_vel);