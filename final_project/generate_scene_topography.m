function scene = generate_scene_topography(terrain_type)
    color.Gray = 0.651*ones(1,3);
    color.Green = [0.3922 0.8314 0.0745];
    color.Red = [1 0 0];
    color.Orange = [0.6071, 0.3929, 0];
    color.Blue = [0 0 1];
    color.Purple = [0.5 0 0.5];
    color.Indigo = [0.2941, 0, 0.5098];
    color.Cyan = [0 0.7176 0.9216];

    if terrain_type == "varied"
        scene = uavScenario("UpdateRate", 2, "ReferenceLocation", [0,0,0]); % The [0,0,0] reference location is the scenario origin. Set to the initial AUV position. 
        
        
        %% Create the sea floor topography
        % addMesh options are polygon, cylinder, custom, terrain, surface, buildings
        % Add a baseline flat, square bottom. 500x500 meters. 
        addMesh(scene, "polygon", {[-500 -500; 500 -500; 500 500; -500 500],[-4 0]}, color.Gray) % Creates a base layer for the sea floor that's 500 meters x 500 meters
        
        % Add in cylinders that define a low-resolution landscape
        % Colors correspond to a 10m increase in height. From low to high:
        % Purple, Blue, Green, Orange, Red
        

        % Structure 1
        addMesh(scene, "Cylinder", {[250, -100, 120], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[250, -60, 60], [10,20]}, color.Purple)
        addMesh(scene, "Cylinder", {[250, -60, 40], [20,30]}, color.Blue)
        addMesh(scene, "Cylinder", {[250, -60, 30], [30,40]}, color.Cyan)
        addMesh(scene, "Cylinder", {[250, -60, 20], [40,50]}, color.Green)
        
        addMesh(scene, "Cylinder", {[250, -170, 40], [10,20]}, color.Purple)
        addMesh(scene, "Cylinder", {[250, -170, 30], [20,30]}, color.Blue)
        
%         % Structure 2
%         addMesh(scene, "Cylinder", {[-300, -400, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
%         addMesh(scene, "Cylinder", {[-300, -400, 40], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
%         addMesh(scene, "Cylinder", {[-300, -400, 20], [20,30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
% 
%         % Structure 3
%         addMesh(scene, "Cylinder", {[-350, -300, 40], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
%         addMesh(scene, "Cylinder", {[-350, -300, 20], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
%     

        % Structure 4
        addMesh(scene, "Cylinder", {[-400, -100, 70], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-400, -100, 60], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-400, -100, 40], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-400, -100, 30], [30, 40]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-400, -100, 20], [40, 50]}, color.Green) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 5
        addMesh(scene, "Cylinder", {[-300, 80, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, 80, 30], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, 80, 20], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 6
        addMesh(scene, "Cylinder", {[-270, 200, 30], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 7
        addMesh(scene, "Cylinder", {[-270, 350, 80], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 350, 40], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 350, 30], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 350, 10], [30, 40]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 8
        addMesh(scene, "Cylinder", {[0, 350, 140], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 100], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 80], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 60], [30, 40]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 30], [40, 50]}, color.Green) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 9
        addMesh(scene, "Cylinder", {[200, 400, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[200, 400, 25], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 10
        addMesh(scene, "Cylinder", {[360, 430, 60], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[360, 430, 40], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[360, 430, 20], [20,30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 11
        addMesh(scene, "Cylinder", {[350, 200, 150], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[350, 200, 125], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

    end
    if terrain_type == "varied_old"
        scene = uavScenario("UpdateRate", 2, "ReferenceLocation", [0,0,0]); % The [0,0,0] reference location is the scenario origin. Set to the initial AUV position. 
        

        
        %% Create the sea floor topography
        % addMesh options are polygon, cylinder, custom, terrain, surface, buildings
        % Add a baseline flat, square bottom. 500x500 meters. 
        addMesh(scene, "polygon", {[-500 -500; 500 -500; 500 500; -500 500],[-4 0]}, color.Gray) % Creates a base layer for the sea floor that's 500 meters x 500 meters
        
        % Add in cylinders that define a low-resolution landscape
        % Colors correspond to a 10m increase in height. From low to high:
        % Purple, Blue, Green, Orange, Red
        

        % Structure 1
        addMesh(scene, "Cylinder", {[200, -200, 240], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[200, -100, 120], [10,20]}, color.Purple)
        addMesh(scene, "Cylinder", {[200, -100, 80], [20,30]}, color.Blue)
        addMesh(scene, "Cylinder", {[200, -100, 60], [30,40]}, color.Cyan)
        addMesh(scene, "Cylinder", {[200, -100, 40], [40,50]}, color.Green)
        
        addMesh(scene, "Cylinder", {[200, -350, 80], [10,20]}, color.Purple)
        addMesh(scene, "Cylinder", {[200, -350, 60], [20,30]}, color.Blue)
        
        % Structure 2
        addMesh(scene, "Cylinder", {[-300, -400, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, -400, 40], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, -400, 20], [20,30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 3
        addMesh(scene, "Cylinder", {[-350, -300, 40], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-350, -300, 20], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
    

        % Structure 4
        addMesh(scene, "Cylinder", {[-290, -170, 70], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-290, -170, 60], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-290, -170, 40], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-290, -170, 30], [30, 40]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-290, -170, 20], [40, 50]}, color.Green) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 5
        addMesh(scene, "Cylinder", {[-300, 0, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, 0, 30], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-300, 0, 20], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 6
        addMesh(scene, "Cylinder", {[-270, 100, 30], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 7
        addMesh(scene, "Cylinder", {[-270, 230, 80], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 230, 40], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 230, 30], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[-270, 230, 10], [30, 40]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 8
        addMesh(scene, "Cylinder", {[0, 350, 140], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 100], [10, 20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 80], [20, 30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 60], [30, 40]}, color.Green) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, 350, 30], [40, 50]}, color.Cyan) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 9
        addMesh(scene, "Cylinder", {[200, 400, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[200, 400, 25], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 10
        addMesh(scene, "Cylinder", {[360, 430, 60], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[360, 430, 40], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[360, 430, 20], [20,30]}, color.Blue) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        % Structure 11
        addMesh(scene, "Cylinder", {[350, 200, 150], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[350, 200, 125], [10,20]}, color.Purple) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

    end
    if terrain_type == "flat"
        scene = uavScenario("UpdateRate", 2, "ReferenceLocation", [0,0,0]); % The [0,0,0] reference location is the scenario origin. Set to the initial AUV position. 

        
        %% Create the sea floor topography
        % addMesh options are polygon, cylinder, custom, terrain, surface, buildings
        % Add a baseline flat, square bottom. 500x500 meters. 
        addMesh(scene, "polygon", {[-500 -500; 500 -500; 500 500; -500 500],[-4 0]}, color.Gray) % Creates a base layer for the sea floor that's 500 meters x 500 meters
        
    end
    if terrain_type == "repeated"
        scene = uavScenario("UpdateRate", 2, "ReferenceLocation", [0,0,0]); % The [0,0,0] reference location is the scenario origin. Set to the initial AUV position. 
        
        color.Gray = 0.651*ones(1,3);
        color.Green = [0.3922 0.8314 0.0745];
        color.Red = [1 0 0];
        color.Orange = [0.6071, 0.3929, 0];
        color.Blue = [0 0 1];
        color.Purple = [0.5 0 0.5];
        
        %% Create the sea floor topography
        % addMesh options are polygon, cylinder, custom, terrain, surface, buildings
        % Add a baseline flat, square bottom. 500x500 meters. 
        addMesh(scene, "polygon", {[-500 -500; 500 -500; 500 500; -500 500],[-4 0]}, color.Gray) % Creates a base layer for the sea floor that's 500 meters x 500 meters
        
        addMesh(scene, "Cylinder", {[0, -300, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[100, -200, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[200, -100, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[300, 0, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[400, 100, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

        addMesh(scene, "Cylinder", {[-100, -250, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[0, -150, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[100, -50, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[200, 50, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall
        addMesh(scene, "Cylinder", {[300, 150, 50], [0,10]}, color.Indigo) % The geometries are defined as {[center_x, center_y, radius], [z_low, z_high]}. The cylinder is z_high - z_low meters tall

    end
end