function [trajectory, orientations] = generate_trajectory(startPos, goalPos)
    % trajectories are: trajectory at timestep i is in the ith row of
    n_steps = (abs(goalPos(1) - startPos(1))/10)+1;
    % create a straight line trajectory
    trajectoryX = linspace(startPos(1), goalPos(1), n_steps); % step 10 meters each time step
    trajectoryY = linspace(startPos(2), goalPos(2), n_steps);
    trajectoryZ = startPos(3)*ones(1, n_steps);
    
    trajectory = [trajectoryX.', trajectoryY.', trajectoryZ.'];
    orientations = [pi/4*ones(n_steps,1), zeros(n_steps,1), zeros(n_steps,1)];
end