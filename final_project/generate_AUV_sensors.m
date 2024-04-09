function [IMU, lidar] = generate_AUV_sensors(AUV)
    % Add a "lidar" sensor that acts as sonar
    % TODO May have to lower lidar resolution to get particle filter to work. right
    % now, it has 360*32 = 11552 measurements. 360 = 120/0.3324099 and 40/1.25 =
    % 32. These numbers come from the resolutions and limits defined below. 
    % lidarmodel = uavLidarPointCloudGenerator(...
    %     "AzimuthResolution", 0.3324099,"AzimuthLimits", [-60 60], "ElevationLimits", [-20 20],...
    %     "ElevationResolution", 1.25, "MaxRange", 90, ...
    %     "HasOrganizedOutput", true, "UpdateRate", 2, "RangeAccuracy", 3); % TODO set RangeAccuracy (=1 standard deviation)
    
    % Lower resolution lidar. Has 352 measurements. TODO see if this could be
    % raised or maybe needs to be lowered.
    lidarmodel = uavLidarPointCloudGenerator(...
        "AzimuthResolution", 0.6667*4,"AzimuthLimits", [-60 60], "ElevationLimits", [-20 20],...
        "ElevationResolution", 1.25, "MaxRange", 90, ...
        "HasOrganizedOutput", true, "UpdateRate", 2, "RangeAccuracy", 0.002); % RangeAccuracy =1 standard deviation
    
    % Set up the AUV Lidar
    lidar = uavSensor("Lidar", AUV, lidarmodel,"MountingLocation", [0,0,-4.5], "MountingAngles",[0 90 0]);
    
    % Set up AUV IMU
    insmodel= insSensor('RollAccuracy',0.2,'PitchAccuracy',0.2,'YawAccuracy',1,'PositionAccuracy',1,'VelocityAccuracy',0.05);
    IMU = uavSensor("INS", AUV, insmodel,"MountingLocation", [0,0,0], "MountingAngles",[0 0 0]);
end