close all;

%% start

% Load data from Simulink To Workspace blocks
simOut = out; % Simulink outputs data as 'out'

% Extract time and position data
time = simOut.tout;  % Time vector
com_pos = simOut.com_position; % COM position
% Extract and reshape Foot position (for some reason it's 1x2xN)
foot_pos = squeeze(simOut.foot_placement_point)'; % Foot position 
knee_pos = squeeze(simOut.knee_position)'; % knee position

% check = size(Foot_pos)

% Extract individual components
x_COM = com_pos(:,1);
y_COM = com_pos(:,2);
x_foot = foot_pos(:,1);
y_foot = foot_pos(:,2);
x_knee = knee_pos(:,1);
y_knee = knee_pos(:,2);

% Set animation speed factor (1 = real-time, >1 = faster, <1 = slower)
animation_speed = 0.25;  

%% Sanity check, to see if knee-com and knee-foot distances stay equal to segment length

% % Compute distances at each timestep
% dist_COM_Knee = sqrt((x_COM - x_knee).^2 + (y_COM - y_knee).^2);
% dist_Knee_Foot = sqrt((x_knee - x_foot).^2 + (y_knee - y_foot).^2);
% 
% % Plot distances vs. time
% f1 = figure;
% hold on;
% grid on;
% plot(time, dist_COM_Knee, 'b', 'LineWidth', 2); % COM-Knee distance in blue
% plot(time, dist_Knee_Foot, 'r', 'LineWidth', 2); % Knee-Foot distance in red
% 
% % Labels and legend
% xlabel('Time (s)');
% ylabel('Distance (m)');
% title('Distance Between Body Segments Over Time');
% legend('COM-Knee', 'Knee-Foot');

%% jumping animation
% Initialize figure
f2 = figure;

% Plot initial positions
h_COM = plot(x_COM(1), y_COM(1), 'bo', 'MarkerSize', 15, 'MarkerFaceColor', 'b'); % COM

hold on;

h_foot = plot(x_foot(1), y_foot(1), 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'r'); % Foot
h_knee = plot(x_knee(1), y_knee(1), 'ro', 'MarkerSize', 2, 'MarkerFaceColor', 'r'); % Knee
ck_line = plot([x_COM(1), x_knee(1)], [y_COM(1), y_knee(1)], 'k-', 'LineWidth', 2); % Connecting line from com to knee
fk_line = plot([x_knee(1), x_foot(1)], [y_knee(1), y_foot(1)], 'k-', 'LineWidth', 2); % Connecting line from knee to foot

grid on;
axis equal;
xlim([-1,1]);
ylim([-0.5,1.5]);

%% animation start

% Initialize video writer
v = VideoWriter('jumping_animation.mp4', 'MPEG-4'); % Create video object
v.FrameRate = 30; % Set frame rate (adjust as needed)
open(v); % Open the video file

% Start real-time animation
tic; % Start timer
t = 0;

while t < time(end)
    t = toc * animation_speed; % Update time
    
    % Find the closest time index
    [~, i] = min(abs(time - t));
    
    % Update plot
    set(h_COM, 'XData', x_COM(i), 'YData', y_COM(i));
    set(h_foot, 'XData', x_foot(i), 'YData', y_foot(i));
    set(h_knee, 'XData', x_knee(i), 'YData', y_knee(i));
    set(ck_line, 'XData', [x_COM(i), x_knee(i)], 'YData', [y_COM(i), y_knee(i)]);
    set(fk_line, 'XData', [x_knee(i), x_foot(i)], 'YData', [y_knee(i), y_foot(i)]);
    
    drawnow; % Refresh plot

    % Capture frame and write to video
    frame = getframe(f2);
    writeVideo(v, frame);

end

% Close the video file
close(v);
disp('Video saved successfully.');