clc; clear; close all;
dof   = 7;

ee_pos_train = tdfread('../all_data/dataSet2/trainingData/dataEE_xyz.txt', '\t');
ee_pos_train = ee_pos_train.dataEE_xyz;

ee_pos_test = tdfread('../all_data/dataSet2/testingData/dataEE_xyz.txt', '\t');
ee_pos_test = ee_pos_test.dataEE_xyz;

time_train   = tdfread('../all_data/dataSet2/trainingData/dataTime.txt', '\t');
time_train   = time_train.dataTime;

time_test   = tdfread('../all_data/dataSet2/testingData/dataTime.txt', '\t');
time_test   = time_test.dataTime;

% creating color signature based on time
cmap = colormap(winter);
c_train = round(1+(size(cmap,1)-1)*(time_train - min(time_train))/(max(time_train)-min(time_train)));
c_test = round(1+(size(cmap,1)-1)*(time_test - min(time_test))/(max(time_test)-min(time_test)));
% c = 0.1*c;

save('ptCloudVariables');

%%
set(gcf,'Renderer','painters')
last = length(c_train);

subplot(2,1,1);
scatter3(ee_pos_train(1:last,1), ee_pos_train(1:last,2), ee_pos_train(1:last,3), ...
    20, c_train(1:last,1), 'filled'); grid on;
caxis([min(time_train) max(time_train)])
colorbar

xlabel('x-axis','Interpreter','latex');
ylabel('y-axis','Interpreter','latex');
zlabel('z-axis','Interpreter','latex');
title('Point Cloud of Training Trajectory','Interpreter','latex');
view([-30 45])


subplot(2,1,2);
last = length(c_test);

scatter3(ee_pos_test(1:last,1), ee_pos_test(1:last,2), ee_pos_test(1:last,3), ...
    20, c_test(1:last,1), 'filled'); grid on;
caxis([min(time_test) max(time_test)])
colorbar

xlabel('x-axis','Interpreter','latex');
ylabel('y-axis','Interpreter','latex');
zlabel('z-axis','Interpreter','latex');
title('Point Cloud of Test Trajectory','Interpreter','latex');