% Define the timestep for the simulation
dt = 1;
rangeAccuracy = 0.002; % standard deviation for lidar measurements
AUV_altitude = 80;

% Set up the AUV scenario
%%% These were the start and end positions used for showing different
%%% bathymetry effects
% startPos = [0, -300, AUV_altitude];
% goalPos = [300, 0, AUV_altitude];
startPos = [-450, -450, AUV_altitude];
goalPos = [450, 450, AUV_altitude];

color.Gray = 0.651*ones(1,3);
color.Green = [0.3922 0.8314 0.0745];
color.Red = [1 0 0];
color.Orange = [0.6071, 0.3929, 0];
color.Blue = [0 0 1];
color.Purple = [0.5 0 0.5];

% Generate the topography for the scene
% scene = generate_scene_topography("flat");
% scene = generate_scene_topography("repeated");
scene = generate_scene_topography("varied");


% Create an AUV with sensors
AUV = generate_AUV_object(startPos, scene, "AUV");
[IMU, lidar] = generate_AUV_sensors(AUV);

% Generate the trajectory the AUV follows using dynamic programming
[trajectory, orientations] = generate_trajectory(startPos, goalPos);
load DP_trajectory.mat

trajectoryLength = size(trajectory, 1);


% Create a separate AUV object to use for getting predicted particle
% measurements
particles_meas_AUV = generate_AUV_object(startPos, scene, "Particles_AUV");
[particles_IMU, particles_lidar] = generate_AUV_sensors(particles_meas_AUV);
n_measurements = 1408;

% Number of particles to use for the particle filter
N_particles = 500;

% Multivariate Gaussian distribution for initial position estimate 
mu0 = [-470, -405];
sigma0 = 50^2*eye(2);

% values used for slideshow examples (non-DP trajectory)
% mu0 = [-50, -250];
% sigma0 = 80^2*eye(2);


mu_hist = zeros(2, trajectoryLength);
mu_hist(:,1) = mu0.';
particles_hist = zeros(2, N_particles, trajectoryLength);
% PF_predict_AUV = AUV;

particleStates = mvnrnd(mu0, sigma0, N_particles).'; % 2xN_particles
W = ones(1,N_particles)/N_particles; % Initialize uniform weights
% disp(particleStates)

[ax, plotFrames] = show3D(scene);
setup(scene)
move(AUV, [trajectory(1,:), zeros(1,6), eul2quat(orientations(1, :)), zeros(1,3)]);

for idx = 2:trajectoryLength
    updateSensors(scene);
    [isupdatedLidar, lidarSampleTime, pt] = read(lidar);
    [isupdatedIMU, IMUSampleTime, IMUReadings]  = IMU.read();
%     IMU_est_pos = IMUReadings.Position(1:2); % Don't use this for PF. Here, it has prior info on the initial position, so going to ignore this since that wouldn't happen in real life.
%     IMU_est_vel = IMUReadings.Velocity(1:2); % Will just used a fixed velocity instead of getting reading from this
    
%     vel_meas = 10 + mvnrnd(0, 0.05^2); % The AUV velocity is 10 by default. Assuming each simulation step is one second. Using same velocity noise as the IMU
    % vel_meas = sqrt(200) + mvnrnd(0, 0.05^2);
    vel_meas = 10 + mvnrnd(0, 0.2^2); % velocity for DP planned trajectory
    IMU_est_angle = orientations(idx,1) + mvnrnd(0, 0.005^2);
    % IMU_est_angle = pi/4 + mvnrnd(0, 0.005^2);

%     IMU_est_orientation = quat2eul(IMUReadings.Orientation, "XYZ"); % Get estimated z rotation from IMU
%     IMU_est_angle = IMU_est_orientation(3); % Get estimated z rotation from IMU
%     disp(IMU_est_orientation)
%     disp(orientations(idx,:))
    
    
    PX = zeros(N_particles, 1);
    if idx>0
        if isupdatedLidar
            measurement = pt.Location;
            probs = zeros(1,N_particles);
            for m = 1:N_particles
                particle = particleStates(:,m);
                % Move the fake PF AUV to the particle location and get the
                % expected measurement 
                move(particles_meas_AUV, [[particle(1), particle(2), AUV_altitude], zeros(1,6), eul2quat([IMU_est_angle, 0, 0]), zeros(1,3)])
                updateSensors(scene);
                [particles_update, particles_tsamp, pred_pt] = read(particles_lidar);
                
                predicted_measurement = pred_pt.Location;
                

                error = [];
                for idx2 = 1:n_measurements
                    if ~isnan(predicted_measurement(idx2))
                        if ~isnan(measurement(idx2))
                            error = [error; measurement(idx2) - predicted_measurement(idx2)]; % put into a vector the differences in measurements that aren't NaNs.
                        end
                    end
                end
                
                % Set up the covariance matrix for measurement noise
                R = rangeAccuracy^2*eye(size(error, 1));

                % Calculate the probability of the measurement 
                if size(error)==0 % If this happens, that means all the measurements are NaNs. In other words, the particle moved off the map, so we'll want to get rid of it. 
                    px = 0;
                else
                    px = exp((-1/2)*(transpose(error)) * R * (error));
                end
                probs(m) = px;
            end
%             disp(probs)
        end
        particles_hist(:,:,idx) = particleStates;
        
        % Generate MSE for particles, avoid resampling if it's too low. 
        MSE_particles = 0;
        for i = 1:N_particles
            MSE_particles = MSE_particles + norm(particleStates(:,i) - mean(particleStates, 2));
        end
        MSE_particles = 1/N_particles * MSE_particles;
        % disp(MSE_particles)
        
        if MSE_particles >= 15
            % Reweight particles and do importance resampling if variance
            % is high enough
            W = probs/sum(probs);
            indices = linspace(1,N_particles,N_particles); % Create list of indices
            resampling = randsample(indices,N_particles,true,W); % Generate a list of indices, sampled according to weights W
            X_old = particleStates;
            W_old = W;
            for idx4 = indices
                new_idx = resampling(idx4); % Pick the randomly sampled index
                particleStates(:,idx4) = X_old(:,new_idx); % Rewrite our particles according to the sampled particles.
                W(idx4) = W_old(new_idx); % Assign the correct weight 
            end
            W = W/sum(W);
        else
            % disp(MSE_particles)
            % disp(size(particleStates))
            % disp(size(W))
            % Reinitialize particles if variance becomes too low
            estimated_state = sum((particleStates.*W).').'; % use weighted mean as mu_est
            sigmaReinitialize = 50^2*eye(2);
            particleStates = mvnrnd(estimated_state, sigmaReinitialize, N_particles).';
        end

        estimated_state = sum((particleStates.*W).').'; % use weighted mean as mu_est

%         particleStates = mvnrnd(estimated_state, sigma0, N_particles).'; % 2xN_particles
%         disp(estimated_state)
        mu_hist(:,idx) = estimated_state;
        move(particles_meas_AUV, [[estimated_state(1), estimated_state(2), AUV_altitude], zeros(1,6), eul2quat([IMU_est_angle, 0, 0]), zeros(1,3)])

        % Show the AUV moving in the simulation
        show_scene(scene, lidarSampleTime, ax)

        % Show the AUV sonar data
%         show_data(pt);
        
        % refresh the scene
%         disp(idx)
        refreshdata
        drawnow limitrate
    end

    advance(scene);

    % Propagate the particles
    for idx3 = 1:N_particles
        particle = particleStates(:,idx3);
        particleStates(:,idx3) = [particle(1) + dt*vel_meas*(cos(IMU_est_angle)), particle(2) + dt*vel_meas*(sin(IMU_est_angle))];  % TODO changed to -cos and -sin. Might cause issues.
    end


    % Propagate the AUV
    if idx < trajectoryLength
        move(AUV, [trajectory(idx+1,:), zeros(1,6), eul2quat([IMU_est_angle,0,0]), zeros(1,3)]);
    end

    updateSensors(scene);
    disp("Updating simulation... ");
    disp([num2str(idx), '/' , num2str(trajectoryLength)]);
end
disp("Complete");

figure(2);
hold on;
plot(mu_hist(1,:), mu_hist(2,:))
plot(trajectory(:,1), trajectory(:,2))
legend(["Estimated Position", "True Position"])
title("Particle Filter Results (Varied Terrain Full Trajectory, 200 Particles)")
xlabel("X Position")
ylabel("Y Position")
xlim([-500, 500])
ylim([-500, 500])
hold off;

figure(4);
hold on;
plot(sqrt((mu_hist(1,:) - trajectory(:,1).').^2 + (mu_hist(2,:) - trajectory(:,2).').^2))
title("Position Estimate Error (Euclidean Distance, 200 Particles)")
ylim([0, 90])
xlabel("Time")
ylabel("Error")
hold off;

% save simple_case_repeated.mat mu_hist
% save simple_case_traj.mat trajectory

% figure(3)
% title("Particle distribution over time")
% for idx=1:trajectoryLength
%     hold on
%     scatter(particles_hist(1,:,idx), particles_hist(2,:,idx+1), 1, [0,0,1], 'filled')
% end

function show_scene(scene, lidarSampleTime, ax)
        % display actual simulation
        show3D(scene, "Time", lidarSampleTime, "FastUpdate", true, "Parent", ax); %
end

function show_data(pt)
%       display point cloud from lidar
        pcshow(pt, VerticalAxis="X", VerticalAxisDir="Down") % Display point cloud from lidar
        xlabel("Z")
        ylabel("Y")
        zlabel("X")
        colorbar
        colormap("winter")
end

% pcshow(pt)

% AUV_x = 0;
% AUV_y = 0;
% xlim([AUV_x - 50, AUV_x + 50]) % Use this later. When running the simulation, want to define axis limits to center on where the AUV is
% ylim([AUV_y - 50, AUV_y + 50])
% zlim([0, 250])
