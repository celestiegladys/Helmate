function [orientation, angular_vel, linear_acc] = kalman_filter(w, a, t, x0, P0, Q, R)

%KALMAN_FILTER Implements a Kalman filter for estimating orientation,
%angular velocity, and linear acceleration from IMU readings.
%
% Inputs:
% w: angular velocity readings (n x 3)
% a: linear acceleration readings (n x 3)
% t: timestamp readings (n x 1)
% x0: initial state estimate (7 x 1)
% P0: initial error covariance (7 x 7)
% Q: process noise covariance (6 x 6)
% R: measurement noise covariance (6 x 6)
%
% Outputs:
% orientation: orientation quaternion (n x 4)
% angular_vel: angular velocity (n x 3)
% linear_acc: linear acceleration (n x 3)
% define time vector
n = length(t);
orientation = zeros(n, 4);
angular_vel = zeros(n, 3);
linear_acc = zeros(n, 3);

x = x0;
P = P0;

for i = 1:n
    dt = t(i) - t(max(i-1, 1));
    
    % State transition matrix
    A = eye(7) + [zeros(3) -skew(w(i,:))*dt zeros(3); zeros(3) eye(3)*dt zeros(3); zeros(3) zeros(3) eye(3)*dt; zeros(3, 7)];
 
    % Input matrix
    B = [zeros(3); eye(4)];
    
    % Predict step
    x = A * x;
    P = A * P * A.' + B * Q * B.';
    
    % Measurement vector
    z = [a(i,:) w(i,:)];
    
    % Measurement matrix
    H = [zeros(3) eye(3) zeros(3); zeros(3) zeros(3) eye(3)];
    
    % Kalman gain
    K = P * H.' * inv(H * P * H.' + R);
    
    % Update step
    x = x + K * (z.' - H * x);
    P = (eye(7) - K * H) * P;
    
    % Extract orientation quaternion, angular velocity, and linear
    % acceleration from state estimate
    orientation(i,:) = x(1:4).';
    angular_vel(i,:) = x(5:7).';
    linear_acc(i,:) = a(i,:) + quatrotate(orientation(i,:), [0 0 9.81]);
end

end

function S = skew(w)
%SKEW Returns the skew-symmetric matrix of a 3D vector
S = [0 -w(3) w(2); w(3) 0 -w(1); -w(2) w(1) 0];
end
