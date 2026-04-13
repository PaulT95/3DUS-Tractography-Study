function new_plot_3d_volume_with_sliders(MaskedVol, X, Y, Z, fascicles, fname, Apo, TA, Cmap_arranged, XYZUVW, Landmark)
Green = [0.55, 0.68, 0.06]; % Green
Orange = [212/256, 126/256, 47/256]; % Orange
red_color =  "#91171b"; % Red fiber

% Create figure and axes
fig = figure('Name','3D Volume Viewer','NumberTitle','off','WindowState', 'maximized');
ax1 = axes('Parent',fig);
axis(ax1,'equal','tight','vis3d');
xlabel(ax1,'X (mm)'); ylabel(ax1,'Y (mm)'); zlabel(ax1,'Z (mm)');
title(ax1,fname);
grid(ax1,'on'); hold(ax1,'on'); daspect([1,1,1]);
xlim(ax1,[min(X(:)),max(X(:))]); ylim(ax1,[min(Y(:)),max(Y(:))]); zlim(ax1,[min(Z(:)),max(Z(:))]);
rotate3d on; colormap(gray)

% Initial states
xy_frame=1; yz_frame=1; xz_frame=1;
show_xy_image=true; show_yz_image=true; show_xz_image=true;
show_apo_mesh=false; show_ta_mesh=false;
show_vector_field=false; show_fascicles=false;
show_landmark = false;

plot_planes_and_fascicles(xy_frame,yz_frame,xz_frame,MaskedVol,X,Y,Z,fascicles,Green,Orange,ax1,...
    show_xy_image,show_yz_image,show_xz_image,show_apo_mesh,show_ta_mesh,Apo,TA,Cmap_arranged,show_vector_field,show_fascicles,...
    XYZUVW, Landmark, show_landmark);

%% ---------------- SLIDERS ----------------
uicontrol('Style','text','String','XY Plane','Position',[10,20,60,20]);
xy_frame_label=uicontrol('Style','text','String',num2str(xy_frame),'Position',[510,20,40,20]);
xy_slider=uicontrol('Style','slider','Min',1,'Max',size(MaskedVol,3),'Value',xy_frame,...
    'Position',[100,20,400,20],'Sliderstep',[1/size(MaskedVol,3) 1],'Callback',@(src,event) update_xy_plot());

uicontrol('Style','text','String','XZ Plane','Position',[10,50,60,20]);
yz_frame_label=uicontrol('Style','text','String',num2str(yz_frame),'Position',[510,50,40,20]);
yz_slider=uicontrol('Style','slider','Min',1,'Max',size(MaskedVol,1),'Value',yz_frame,...
    'Position',[100,50,400,20],'Sliderstep',[1/size(MaskedVol,1) 1],'Callback',@(src,event) update_yz_plot());

uicontrol('Style','text','String','YZ Plane','Position',[10,80,60,20]);
xz_frame_label=uicontrol('Style','text','String',num2str(xz_frame),'Position',[510,80,40,20]);
xz_slider=uicontrol('Style','slider','Min',1,'Max',size(MaskedVol,2),'Value',xz_frame,...
    'Position',[100,80,400,20],'Sliderstep',[1/size(MaskedVol,2) 1],'Callback',@(src,event) update_xz_plot());

%% ---------------- CHECKBOXES ----------------
% Planes
show_xy_checkbox=uicontrol('Style','checkbox','String','Show XY Image','Value',1,...
    'Position',[600,20,100,20],'Callback',@(src,event) update_show_image());
show_yz_checkbox=uicontrol('Style','checkbox','String','Show XZ Image','Value',1,...
    'Position',[600,50,100,20],'Callback',@(src,event) update_show_image());
show_xz_checkbox=uicontrol('Style','checkbox','String','Show YZ Image','Value',1,...
    'Position',[600,80,100,20],'Callback',@(src,event) update_show_image());

% Meshes
show_apo_checkbox=uicontrol('Style','checkbox','String','Show Apo Mesh','Value',0,...
    'Position',[750,20,100,20],'Callback',@(src,event) update_show_image());
show_ta_checkbox=uicontrol('Style','checkbox','String','Show TA Mesh','Value',0,...
    'Position',[750,50,100,20],'Callback',@(src,event) update_show_image());

% Vector field & Fascicles (mutually exclusive)
show_vec_checkbox=uicontrol('Style','checkbox','String','Show Vector Field','Value',0,...
    'Position',[900,20,130,20],'Callback',@(src,event) toggle_exclusive('vector'));
show_fas_checkbox=uicontrol('Style','checkbox','String','Show Fascicles','Value',0,...
    'Position',[900,50,130,20],'Callback',@(src,event) toggle_exclusive('fascicles'));
%Landmarks
show_landmark_checkbox=uicontrol('Style','checkbox','String','Show Landmark','Value',0,...
    'Position',[900,80,150,20],'Callback',@(src,event) toggle_exclusive('landmark'));

%% ---------------- CALLBACKS ----------------
    function toggle_exclusive(option)
        if strcmp(option,'vector')
            show_vector_field = get(show_vec_checkbox,'Value');
            %if show_vector_field, set(show_fas_checkbox,'Value',0); show_fascicles=false; end
        elseif strcmp(option,'fascicles')
            show_fascicles = get(show_fas_checkbox,'Value');
            %if show_fascicles, set(show_vec_checkbox,'Value',0); show_vector_field=false; end
        elseif strcmp(option,'landmark')
           show_landmark = get(show_landmark_checkbox,'Value');
           %if show_landmark, set(show_landmark_checkbox,'Value',0); show_landmark=false; end
        end
        update_all();

     end
    

    function update_show_image()
        show_xy_image=get(show_xy_checkbox,'Value');
        show_yz_image=get(show_yz_checkbox,'Value');
        show_xz_image=get(show_xz_checkbox,'Value');
        show_apo_mesh=get(show_apo_checkbox,'Value');
        show_ta_mesh=get(show_ta_checkbox,'Value');
        update_all();
    end

    function update_xy_plot()
        xy_frame=round(get(xy_slider,'Value'));
        set(xy_frame_label,'String',num2str(xy_frame));
        update_all();
    end

    function update_yz_plot()
        yz_frame=round(get(yz_slider,'Value'));
        set(yz_frame_label,'String',num2str(yz_frame));
        update_all();
    end

    function update_xz_plot()
        xz_frame=round(get(xz_slider,'Value'));
        set(xz_frame_label,'String',num2str(xz_frame));
        update_all();
    end

    function update_all()
        cla(ax1); % clear axes
        
        plot_planes_and_fascicles(xy_frame,yz_frame,xz_frame,MaskedVol,X,Y,Z,fascicles,Green,Orange,ax1,...
            show_xy_image,show_yz_image,show_xz_image,show_apo_mesh,show_ta_mesh,Apo,TA,Cmap_arranged, ...
            show_vector_field,show_fascicles,XYZUVW,Landmark, show_landmark);
    end
end

%% ---------------- HELPERS ----------------
function plot_planes_and_fascicles(xy_frame,yz_frame,xz_frame,MaskedVol,X,Y,Z,fascicles,Green,Orange,ax,...
    show_xy_image,show_yz_image,show_xz_image,show_apo_mesh,show_ta_mesh,Apo,TA,Cmap_arranged,show_vector_field,show_fascicles,XYZUVW,Landmark,show_landmark)

% Planes
plot_xy_plane(xy_frame,MaskedVol,X,Y,Z,ax,show_xy_image);
plot_yz_plane(yz_frame,MaskedVol,X,Y,Z,ax,show_yz_image,XYZUVW);
plot_xz_plane(xz_frame,MaskedVol,X,Y,Z,ax,show_xz_image);
hold on
% Meshes
if show_apo_mesh
    trisurf(Apo.faces,Apo.vertices(:,1),Apo.vertices(:,2),Apo.vertices(:,3),...
        'EdgeColor','none','FaceVertexCData',Cmap_arranged,'Tag','ApoMesh','FaceAlpha',0.4); hold on
end
if show_ta_mesh
    trisurf(TA.faces,TA.vertices(:,1),TA.vertices(:,2),TA.vertices(:,3),...
        'EdgeColor','#565959','EdgeAlpha',0.25,'FaceAlpha',0.15,'Tag','TAMesh','FaceVertexCData',[0.8 0.8 0.8]);
end

% Vector field OR Fascicles
if show_vector_field && ~isempty(XYZUVW)
    X = XYZUVW{1}; Y = XYZUVW{2}; Z = XYZUVW{3};
    U = XYZUVW{4}; V = XYZUVW{5}; W = XYZUVW{6};

    % Optional: downsample so it's not too dense or going crazy
    step = 1;
    quiver3(X(1:step:end,1:step:end,1:step:end), ...
        Y(1:step:end,1:step:end,1:step:end), ...
        Z(1:step:end,1:step:end,1:step:end), ...
        U(1:step:end,1:step:end,1:step:end), ...
        V(1:step:end,1:step:end,1:step:end), ...
        W(1:step:end,1:step:end,1:step:end),5, 'Color','r');
  
elseif show_fascicles && ~isempty(fascicles)

    if numel(fascicles) > 5000
        htubes = streamtube(fascicles(1:2:end), 0.85); % Create the streamtubes
    else
        htubes = streamtube(fascicles, 0.85); % Create the streamtubes
    end

    set(htubes, 'EdgeColor', 'none','FaceColor',"#a8373c",'FaceAlpha',0.7);
    % Keep the "fancy" effects
    %shading interp; <-- it makes it super slow
    camlight;
    lighting gouraud
end

if show_landmark && ~isempty(Landmark)
    plot3(Landmark(:,1),Landmark(:,2),Landmark(:,3),'o','MarkerSize',14,'LineWidth',5,'Color',Green);
    %create a stupid cell with strings to just attached next to the
    %landmark
    text_L = num2cell((1:1:size(Landmark,1)));
    text(Landmark(:,1).*0.95,Landmark(:,2).*0.95,Landmark(:,3).*0.95,text_L,'FontSize',18)
end

xlabel(ax,'X (mm)'); ylabel(ax,'Y (mm)'); zlabel(ax,'Z (mm)');
xlim(ax,[min(X(:)),max(X(:))]); ylim(ax,[min(Y(:)),max(Y(:))]); zlim(ax,[min(Z(:)),max(Z(:))]);

%plot axes orientations from min to max
factor = 15;

%I should get the mid point o
limits = [ (get(gca,'XLim'))' (get(gca,'YLim'))' (get(gca,'ZLim'))' ] * 1.1;
origin = [min(X(:)) min(Y(:)) min(Z(:))]; %origin axis plot
x_axis = [min(X(:))+factor min(Y(:)) min(Z(:))];
y_axis =  [min(X(:)) min(Y(:))+factor min(Z(:))];
z_axis =  [min(X(:)) min(Y(:)) min(Z(:))+factor];

%plto reference axes
hold on
    mArrow3(origin,x_axis,'color','red','stemWidth',0.02*factor,'facealpha',0.7);
    mArrow3(origin,y_axis,'color','green','stemWidth',0.02*factor,'facealpha',0.7);
    mArrow3(origin,z_axis,'color','blue','stemWidth',0.02*factor,'facealpha',0.7);

%camlight('headlight');
%lighting gouraud;
grid(ax,'on'); hold(ax,'off');
view(3)
axis equal
hold off
end


%% ------------------- PLANE PLOTTERS -------------------
function plot_xy_plane(frame, MaskedVol, X, Y, Z, ax, show_flag)
if show_flag
    sliceZ = Z(:,:,frame);
    sliceX = X(:,:,frame);
    sliceY = Y(:,:,frame);
    img = squeeze(MaskedVol(:,:,frame));
    surface(sliceX, sliceY, sliceZ, img, ...
        'Parent', ax, ...
        'EdgeColor', 'none', ...
        'FaceColor', 'texturemap','FaceAlpha',0.8,'FaceLighting','none');
end
end

function plot_yz_plane(frame, MaskedVol, X, Y, Z, ax, show_flag,XYZUVW)
if show_flag
    sliceX = squeeze(X(frame,:,:));
    sliceY = squeeze(Y(frame,:,:));
    sliceZ = squeeze(Z(frame,:,:));
    img = squeeze(MaskedVol(frame,:,:));
    surface(sliceX, sliceY, sliceZ, img, ...
        'Parent', ax, ...
        'EdgeColor', 'none', ...
        'FaceColor', 'texturemap','FaceAlpha',0.8,'FaceLighting','none');
        % if you wamt to plot local 3D vectors. just that I can recall the code fpr paper purposes%
        % because here I don't have the seeds points
        % slice_loc = mean(squeeze(Y(frame,:,:)));        % Slice location (mm)
        % slice_thresh = 2;         % +/- threshold around the slice (mm)
        % distance_threshold = 2;    % Aponeurosis distance threshold (mm)
        % 
        % dists = abs(abs(seed_points(:,2)) - slice_loc);%get abs distance
        % valid_idx = dists <= distance_threshold;
        % filtered_seed_points  = seed_points(valid_idx, :);
        % filtered_seed_vectors = seed_vectors(valid_idx, :);       
        slice_vec_field(sliceY(1,1),XYZUVW);

end
end

function plot_xz_plane(frame, MaskedVol, X, Y, Z, ax, show_flag)
if show_flag
    sliceX = squeeze(X(:,frame,:));
    sliceY = squeeze(Y(:,frame,:));
    sliceZ = squeeze(Z(:,frame,:));
    img = squeeze(MaskedVol(:,frame,:));
    surface(sliceX, sliceY, sliceZ, img, ...
        'Parent', ax, ...
        'EdgeColor', 'none', ...
        'FaceColor', 'texturemap','FaceAlpha',0.8);
end
end


%helper function for plotting fancy factor field around the current slice

function slice_vec_field(mmPos,XYZUVW)
        thresh = 3;             % ±3 mm range
        
        %get vector field 
        X = XYZUVW{1}; Y = XYZUVW{2}; Z = XYZUVW{3};
        U = XYZUVW{4}; V = XYZUVW{5}; W = XYZUVW{6};
        % Flatten everything to make my life easire and also for marrow3
        % plotting logic
        Xp = X(:); Yp = Y(:); Zp = Z(:);
        Up = U(:); Vp = V(:); Wp = W(:);
        
        % Logical mask: points near the desired Y plane of the current
        % slice
        mask = abs(Yp - mmPos) <= thresh;
        

        % Replace invalid entries with NaN
        Xp(~mask) = NaN; Yp(~mask) = NaN; Zp(~mask) = NaN;
        Up(~mask) = NaN; Vp(~mask) = NaN; Wp(~mask) = NaN;
        % Flatten
        filtered_points  = [Xp, Yp, Zp];
        filtered_vectors = [Up, Vp, Wp];
        %just keep valid vectors
        valid_idx = all(~isnan(filtered_vectors), 2) & all(~isnan(filtered_points), 2);
        filtered_points  = filtered_points(valid_idx, :);
        filtered_vectors = filtered_vectors(valid_idx, :);   
        
        if isempty(filtered_vectors) %just return otherwise it just crashes
            return
        end
        factor = 3; %typical size for the analysis
        red_color =  "#e05f63";%red fiber colro
        step = 5; %plot 20% of them
        %plot 20% of vectors
       for i = 1:step:length(filtered_vectors)
            p1 = filtered_points(i,:);
            v  = filtered_vectors(i,:);
            p2 = p1 + factor * v;
            mArrow3(p1, p2, 'color', red_color, 'stemWidth', 0.025*factor, 'facealpha', 0.8);
       end
end