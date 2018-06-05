clc; clear; close all;
pause on;
dof   = 7;

samples = 1;
prevSam = -1;
wf  = tdfread('../data/wf_value.txt', '\t');
wf  = wf.wf_value;
T   = 2*3.1416/wf;
start = 1;

plotType = 1;
while plotType < 3
    while (prevSam ~= samples)
        prevSam = samples;
        
        %% Get states
        if (plotType == 0)
            onlineTime = tdfread('../data/onlineTime.txt');
            onlineTime = onlineTime.onlineTime;
            samples    = size(onlineTime,1);
            onlineTime = onlineTime(start:samples);
            
            onlineQ_ref = tdfread('../data/onlineQ_ref.txt', '\t');
            onlineQ_ref = onlineQ_ref.onlineQ_ref;
            onlineQ_ref = onlineQ_ref(start:samples,:);
            
            pauseTime = 0.1;
        end
        if (plotType == 1)
            onlineTime = tdfread('../data/onlineTime.txt');
            onlineTime = onlineTime.onlineTime;
            samples    = size(onlineTime,1);
            onlineTime = onlineTime(start:samples);
             
            onlineQ_ref = tdfread('../data/onlineQ_ref.txt', '\t');
            onlineQ_ref = onlineQ_ref.onlineQ_ref;
            onlineQ_ref = onlineQ_ref(start:samples,:);
            
            onlineQ_rbd = tdfread('../data/onlineQ_rbd.txt', '\t');
            onlineQ_rbd = onlineQ_rbd.onlineQ_rbd;
            onlineQ_rbd = onlineQ_rbd(start:samples,:);
            pauseTime = 0.1;
        end
        if (plotType == 2)
            onlineQ_pred = tdfread('../data/onlineQ_pred.txt', '\t');
            onlineQ_pred = onlineQ_pred.onlineQ_pred;
            samples = size(onlineQ_pred,1);
            if (samples > maxSamples)
                samples = maxSamples;
            end
            onlineQ_pred = onlineQ_pred(start:samples,:);
            pauseTime = 0.1;
        end
        
        %% Plotting states
        rows = 3; cols = 3;
        for i = 1:dof
            subplot(rows, cols, i);
            
            if plotType == 0
                h1=plot(onlineTime, onlineQ_ref(:,i) ,'r'); hold on;
                leg1 = legend(h1,{'$q_{ref}$'});
            elseif plotType == 1
                h1=plot(onlineTime, onlineQ_ref(:,i) ,'r'); hold on;
                h2=plot(onlineTime(start:length(onlineQ_rbd)), onlineQ_rbd(start:end,i), 'k');
                leg1 = legend([h1,h2],{'$q_{ref}$','$q_{rbd}$'});
            elseif plotType == 2
                h1=plot(onlineTime(start:length(onlineQ_ref)), onlineQ_ref(start:end,i) ,'r'); hold on;
                h3=plot(onlineTime(start:length(onlineQ_pred)),onlineQ_pred(start:end,i), 'b');
                leg1 = legend([h1,h3],{'$q_{ref}$','$q_{pred}$'});
            end
            
            grid on;
            %[a, MSGID] = lastwarn();
            %warning('off', MSGID);
            set(leg1,'Interpreter','latex');            
            xlabel('Time');
            ylabel('Torques');
            title(['Joint ' num2str(i)])
            xlim([0 T+0.5])
        end
        pause(pauseTime);
    end
    disp('Plotted all samples ... Moving to next');
    if (plotType == 1)
        maxSamples = size(onlineTime,1);
        fprintf('[INFO] Setting max sample limit = %d\n', maxSamples);
    end
    plotType = plotType + 1;
    samples = 1;
    prevSam = -1;
    if (plotType == 2)
        pause(1);
    else
        pause(0.5);
    end
    figure;
end

disp('Completed all plots!');
close;

%% Evaluate normalized-MSE on predicted torque and torque from testing set


for i=1:dof
    MSE_joints(i) = compute_MSE(onlineQ_pred(:,i), onlineQ_ref(:,i));
    MSEreal_joints(i) = compute_MSE(onlineQ_rbd(:,i), onlineQ_ref(:,i));
end
fprintf('nMSE between predicted torque and actual torque:\n');
disp(MSE_joints);


fprintf('nMSE between rbd torque and actual torque:\n');
disp(MSEreal_joints);

%%
fprintf('Order of improvement in prediction:\n');
disp((MSEreal_joints./MSE_joints))
