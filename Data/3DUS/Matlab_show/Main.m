
%clear
clear
clc

% Add required functions to the Matlab path automatically
tmp = mfilename("fullpath");
tmp = erase(tmp,mfilename);
addpath(genpath(tmp))
%pick up the mat file
%uiload();

[fileName, filePath] = uigetfile('*.mat', 'Select elaborated file');

%Check if user clicked Cancel (returns 0)
if fileName == 0
    return;
else
    %
    fullFileName = fullfile(filePath, fileName);

    % Load the data into a structure
    load(fullFileName);

    % fileName variable is now available for use
    disp(['Loaded file: ', fileName]);
end

%% generate the volume slicer using the function I made


if contains(fileName,"Synthetic","IgnoreCase",true)

    %synthetic fascicle volume
    % Retrieve the world limits from RB
    xWorldLimits = RB.XWorldLimits;
    yWorldLimits = RB.YWorldLimits;
    zWorldLimits = RB.ZWorldLimits;
    % Define the number of points in each dimension
    nX = size(fas_vol, 2);
    nY = size(fas_vol, 1);
    nZ = size(fas_vol, 3);

    % Create meshgrid using the world limits and the number of points for
    % image volume
    [Xf, Yf, Zf] = meshgrid(linspace(xWorldLimits(1), xWorldLimits(2), nX), ...
        linspace(yWorldLimits(1), yWorldLimits(2), nY), ...
        linspace(zWorldLimits(1), zWorldLimits(2), nZ));

    clearvars       xWorldLimits yWorldLimits zWorldLimits nX nY nZ

    %the fas_mesh is plot as "TA mesh" in the GUI
    new_plot_3d_volume_with_sliders(fas_vol, Xf, Yf, Zf, fibers, 'file', Fake_apo_mesh, Fas_mesh, [0 1 0], {X,Y,Z,U,V,W}, Landmarks)

else

    %% Create GRIDs of transformed volume for plotting purpose

    % Retrieve the world limits from RB
    xWorldLimits = RB.XWorldLimits;
    yWorldLimits = RB.YWorldLimits;
    zWorldLimits = RB.ZWorldLimits;
    % Define the number of points in each dimension
    nX = size(MaskedVol, 2);
    nY = size(MaskedVol, 1);
    nZ = size(MaskedVol, 3);

    % Create meshgrid using the world limits and the number of points for
    % image volume
    [Xf, Yf, Zf] = meshgrid(linspace(xWorldLimits(1), xWorldLimits(2), nX), ...
        linspace(yWorldLimits(1), yWorldLimits(2), nY), ...
        linspace(zWorldLimits(1), zWorldLimits(2), nZ));

    clearvars       xWorldLimits yWorldLimits zWorldLimits nX nY nZ

    if contains(fileName,"Real_fake","IgnoreCase",true)
        %use the following function if you want to see the Phantom wire fascicle
        %volume (this was the 3x3x3 mm^3 voxel size)
        new_plot_3d_volume_with_sliders(MaskedVol, Xf, Yf, Zf, fibers, 'file', Apo, [], [0 1 0], {X,Y,Z,U,V,W}, Landmark)
    else%//default case is a TA or whatever output of the script

        %FYI:
        %Cmap arranged is the colormap based on the width of aponerusis along its
        %main axis. i.e. red = wider, blue = narrower
        new_plot_3d_volume_with_sliders(MaskedVol, Xf, Yf, Zf, fibers, 'file', Apo, TA, Cmap_arranged, {X,Y,Z,U,V,W}, T_landmark)
    end

end
