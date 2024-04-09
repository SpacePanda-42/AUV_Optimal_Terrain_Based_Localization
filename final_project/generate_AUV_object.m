function AUV = generate_AUV_object(startPos, scene, name)
    %% Create the model for the AUV
    % Create the AUV main body
    load ellipsoidmesh.mat % loads {f,v} to define the platform mesh
    AUV = uavPlatform(name, scene, "ReferenceFrame", "ENU", ...
        "InitialPosition", startPos, "InitialOrientation", eul2quat([pi/4 0 0])); % eul2quat([z_rotation, y_rotation, x_rotation]). We only care about 2D trajectories, so only z_rotation should ever be nonzero.
    
    AUV.updateMesh("custom", {v,f}, [1 1 0], [0 0 0], [1 0 0 0]); % Set mesh to AUV-looking mesh
    
end