clc; clear; close all;
load gpVariables
load alphaVariable

onlinexq = tdfread('../data/onlinexq.txt');
onlinexq = onlinexq.onlinexq;
onlinexq = onlinexq(2:end,:);
%%
for j=1:num_test_samples
    fprintf('Query point %d/%d\n', j, num_test_samples);
    xq = onlinexq(j,:);
    for i=1:num_training_samples
        k(i) = calc_Kernel(hyp2, trainTrajectory(i,:), xq);
    end
    kAlpha(j,:)     = k*alpha;
    kValues(:,j)    = k';
end


%% Plotting torques - predicted torque, PhiBeta test torque, actual test torque
rows = 3;   cols = 3;
for i = 1:7
    subplot(rows, cols, i);
    plot(time_test, kAlpha(:,i),   'b');
    leg1 = legend('$k*\alpha$');
    ylabel('Torque','Interpreter','latex');
    grid on;
    
    xlabel('Time (seconds)','Interpreter','latex');
    set(leg1,'Interpreter','latex');
    title(['Joint ', num2str(i)],'Interpreter','latex');
    
    subplot(rows, cols, i);
    plot(time_test, onlinexq(:,i), 'b',...
        time_test, onlinexq(:,i+7), 'k',...
        time_test, onlinexq(:,i+14), 'r');
    leg1 = legend('$q$','$\dot{q}$','$\ddot{q}$');
    ylabel('State','Interpreter','latex');
    grid on;
    xlabel('Time (seconds)','Interpreter','latex');
    set(leg1,'Interpreter','latex');
    title(['Joint ', num2str(i)],'Interpreter','latex');
    
end

