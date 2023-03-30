% Define the gravitational acceleration
g = 9.81; % m/s^2
imu_rotation;
imu_orientation=data_accleration;

% Convert rotation angles to radians
roll = (imu_rotation(:,1));
pitch = (imu_rotation(:,2));
yaw = (imu_rotation(:,3));

% Define the rotation matrix using the Euler angles
R = [cos(yaw)*cos(pitch), cos(yaw)*sin(pitch)*sin(roll) - sin(yaw)*cos(roll), cos(yaw)*sin(pitch)*cos(roll) + sin(yaw)*sin(roll);
     sin(yaw)*cos(pitch), sin(yaw)*sin(pitch)*sin(roll) + cos(yaw)*cos(roll), sin(yaw)*sin(pitch)*cos(roll) - cos(yaw)*sin(roll);
     -sin(pitch), cos(pitch)*sin(roll), cos(pitch)*cos(roll)];

% Define the gravity vector in the body frame
g_b = [0; 0; -g];


% Define the orientation vector
O = [imu_orientation(:,1); imu_orientation(:,2); imu_orientation(:,3)];

% Subtract the gravity vector from the acceleration vector in the body frame
a_b = R * (O - g_b);

% Extract the vertical acceleration component
a_z = a_b(3);

% Calculate the vertical acceleration in the Earth frame
a = a_z + g;

% Display the result
fprintf('Vertical acceleration: %f m/s^2\n', a);