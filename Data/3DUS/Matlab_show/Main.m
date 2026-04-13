
%clear
clear
clc

% Add required functions to the Matlab path automatically
tmp = mfilename("fullpath");
tmp = erase(tmp,mfilename);
addpath(genpath(tmp))
%pick up the mat file
uiload();

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

%FYI:
%Cmap arranged is the colormap based on the width of aponerusis along its
%main axis. i.e. red = wider, blue = narrower
%% generate the volume slicer using the function I made
new_plot_3d_volume_with_sliders(MaskedVol, Xf, Yf, Zf, fibers, 'file', Apo, TA, Cmap_arranged, {X,Y,Z,U,V,W}, T_landmark)
