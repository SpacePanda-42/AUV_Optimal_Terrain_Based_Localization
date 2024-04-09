x_vals = linspace(-450, 450, 91);
y_vals = linspace(-450, 450, 91);
startPos = [-450, -450];
goalPos = [450, 450];
z = 80;

if ~exist('var_grid.mat')
    % Define the timestep for the simulation
    dt = 1;
    rangeAccuracy = 0.002; % standard deviation for lidar measurements
    AUV_altitude = 80;
    n_measurements = 1408;
    
    % Generate the topography for the scene
    scene = generate_scene_topography("varied");
    
    % Create an AUV with sensors
    AUV = generate_AUV_object([0,0,80], scene, "AUV");
    lidarmodel = uavLidarPointCloudGenerator(...
        "AzimuthResolution", 0.6667*4,"AzimuthLimits", [-60 60], "ElevationLimits", [-20 20],...
        "ElevationResolution", 1.25, "MaxRange", 90, ...
        "HasOrganizedOutput", true, "UpdateRate", 2, 'HasNoise', 0); % RangeAccuracy =1 standard deviation
    
    % Set up the AUV Lidar
    lidar = uavSensor("Lidar", AUV, lidarmodel,"MountingLocation", [0,0,-4.5], "MountingAngles",[0 90 0]);
    
    % Set up AUV IMU
    insmodel= insSensor('RollAccuracy',0.2,'PitchAccuracy',0.2,'YawAccuracy',1,'PositionAccuracy',1,'VelocityAccuracy',0.05);
    IMU = uavSensor("INS", AUV, insmodel,"MountingLocation", [0,0,0], "MountingAngles",[0 0 0]);

    
    setup(scene);
    
    trajectory_x = [];
    trajectory_y = [];
    var_grid = zeros(91, 91);
    
    % Assign values for each point
    for x = 1:91
        disp(x);
        for y = 1:91
            move(AUV, [[x_vals(x), y_vals(y), 80], zeros(1,6), eul2quat([pi/2, 0, 0]), zeros(1,3)]);
            updateSensors(scene);
            [isupdatedLidar, lidarSampleTime, pt] = read(lidar);
    
            readings = [];
            for i = 1:n_measurements
                if ~isnan(pt.Location(i))
                    readings = [readings, pt.Location(i)];
                end
            end
    
            if size(readings,1) == 0
                var_grid(x,y) = 0;
            else
                var_grid(x,y) = -var(readings);
            end
        end
    end
    save var_grid.mat var_grid
else
    load("var_grid.mat");
end



if ~exist('cost_grid.mat')
    % Note: Making the grid world assumption for this; i.e., we must move
    % either up or right at each step for generating a DP solution. This is to
    % force us to end up at the desired terminal state while still being able
    % to generate a path that maximizes terrain variation.
    
    cost_grid = zeros(91, 91);
    cost_grid(91, 91) = 0; % Set zero cost for the terminal state
    
    converged = 0;
    current_node = [91,91];
    parents = [];
    children = [];
    parents = [parents;[91,91]];
    while converged==0
        for parent_idx = 1:size(parents,1)
            parent = parents(parent_idx,:);
            if parent(1) - 1 >= 1
                if size(children,1) > 0
                    if ~ismember([parent(1)-1, parent(2)], children, 'rows')
                        children = [children; [parent(1)-1, parent(2)]];
                    end
                else
                    children = [children; [parent(1)-1, parent(2)]];
                end
            end
            if parent(2) - 1 >= 1
                if size(children,1)>0
                    if ~ismember([parent(1), parent(2)-1], children, 'rows')
                        children = [children; [parent(1), parent(2)-1]];
                    end
                else
                    children = [children; [parent(1), parent(2)-1]];
                end

            end
        end
    
        if size(children, 1) > 0
            for child_idx = 1:size(children,1)
                child = children(child_idx,:);
                child_pars = [];
                if child(1) + 1 <= 91
                    parent1 = [child(1)+1, child(2)];
                    child_pars = [child_pars; parent1];
                end
                if child(2) + 1 <= 91
                    parent2 = [child(1), child(2)+1];
                    child_pars = [child_pars; parent2];
                end
        
                parent_costs = [];
                for child_pars_idx = 1:size(child_pars,1)
                    par = child_pars(child_pars_idx,:);
                    parent_costs = [parent_costs, -(var_grid(par(1), par(2))^2)];
                end
                cost_grid(child(1), child(2)) = min(parent_costs);
            end
        end
    
        % If there are no more children, then we've checked all points. 
        if size(children,1) == 0
            converged = 1;
            break;
        end
        parents = children;
        children = [];
    end
    save cost_grid.mat cost_grid
else
    load('cost_grid.mat')
end




start_loc = [1,1];
cur_loc = start_loc;
location_hist = [start_loc];
converged = 0;
while converged==0
    
    if cur_loc(1)+1 <= 91
        parent_val_1 = cost_grid(cur_loc(1)+1, cur_loc(2));
    else
        parent_val_1 = 1;
    end
    
    if cur_loc(2)+1 <= 91
        parent_val_2 = cost_grid(cur_loc(1), cur_loc(2)+1);
    else
        parent_val_2 = 1;
    end

    if parent_val_1 < parent_val_2
        cur_loc = [cur_loc(1)+1, cur_loc(2)];
    else
        cur_loc = [cur_loc(1), cur_loc(2)+1];
    end
    location_hist = [location_hist; cur_loc];
    if cur_loc == [91,91]
        converged = 1;
        break;
    end
end

x_locs = location_hist(:,1);
y_locs = location_hist(:,2);
orientations = [];

x_trajectory = [];
for idx = 1:size(x_locs,1)
    x_idx = x_locs(idx,1);
    x_trajectory = [x_trajectory, x_vals(1, x_idx)];
    if x_idx <= 90
        if x_locs(idx, 1) - x_locs(idx+1,1) == 0
            orientations = [orientations; [pi/2, 0, 0]];
        else
            orientations = [orientations; [0, 0, 0]];
        end
    end
end

orientations = [orientations; orientations(end,:)];

y_trajectory = [];
for y_idx = y_locs
    y_trajectory = [y_trajectory, y_vals(y_idx)];
end

z_trajectory = 80*ones(1, size(x_trajectory,2));


trajectory = [x_trajectory.', y_trajectory.', z_trajectory.'];
save DP_trajectory.mat trajectory orientations

figure(1);
hold on;
title("Dynamic Programming Trajectory")
plot(x_trajectory, y_trajectory, 'LineWidth', 1.5)
xlabel("X Position")
ylabel("Y Position")
hold off;





