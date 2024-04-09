% Define the timestep for the simulation
dt = 1;
rangeAccuracy = 0.002; % standard deviation for lidar measurements
AUV_altitude = 80;

% Set up the AUV scenario
startPos = [0-700,-700, AUV_altitude];
goalPos = [300, 0, AUV_altitude];

% Generate the topography for the scene
scene = generate_scene_topography("varied");

% Create an AUV with sensors
AUV = generate_AUV_object(startPos, scene, "AUV");
[IMU, lidar] = generate_AUV_sensors(AUV);

% Generate the trajectory the AUV follows
% [trajectory, orientations] = generate_trajectory(startPos, goalPos);
load DP_trajectory.mat


[ax, plotFrames] = show3D(scene);
setup(scene)
n_frames = size(trajectory, 1)-1;
F(n_frames) = struct('cdata', [], 'colormap',[]);

for idx = 1:size(trajectory, 1)-1
    [isupdatedLidar, lidarSampleTime, pt] = read(lidar);
    [isupdatedIMU, IMUSampleTime, IMUReadings]  = IMU.read();
    IMU_est_orientation = quat2eul(IMUReadings.Orientation, "XYZ"); % Get estimated z rotation from IMU
    IMU_est_angle = IMU_est_orientation(3); % Get estimated z rotation from IMU
    
    
    if isupdatedLidar

        % Show the AUV moving in the simulation
        show_scene(scene, lidarSampleTime, ax)


        % Show the AUV sonar data
%         show_data(pt);


        % refresh the scene
        refreshdata
        drawnow limitrate

        % Create a movie for AUV moving in the simulation
%         exportgraphics(gcf, 'animated_traj_repeated.gif', 'Append', true)

        % Create a movie for AUV sonar data
%         record_data(pt);
    end

    advance(scene);

    % Propagate the AUV
%     move(AUV, [trajectory(idx+1,:), zeros(1,6), eul2quat(orientations(idx+1, :)), zeros(1,3)]);

    updateSensors(scene);
end
% fig = figure;
% movie(fig, F, 100)
writeAnimation('test.gif')



function show_scene(scene, lidarSampleTime, ax)
        % display actual simulation
        show3D(scene, "Time", lidarSampleTime, "FastUpdate", true, "Parent", ax); %
        xlim([-500, 500]);
        ylim([-500, 500]);
end

function show_data(pt)
%       display point cloud from lidar
        pcshow(pt, VerticalAxis="X", VerticalAxisDir="Down") % Display point cloud from lidar
        xlabel("Z")
        ylabel("Y")
        zlabel("X")
        xlim([0, 80])
        zlim([-50, 50])
        colorbar
        colormap("winter")
end

% pcshow(pt)


% EXAMPLE: HAVE A PLOT THAT DISPLAYS A REGION CENTERED ON THE AUV
% AUV_x = 0;
% AUV_y = 0;
% xlim([AUV_x - 50, AUV_x + 50]) % Use this later. When running the simulation, want to define axis limits to center on where the AUV is
% ylim([AUV_y - 50, AUV_y + 50])
% zlim([0, 250])
