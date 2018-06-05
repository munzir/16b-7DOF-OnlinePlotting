clc; clear; close all;
pause on;
dof   = 7;

samples = 1;
prevSam = -1;
wf  = tdfread('../data/wf_value.txt', '\t');
wf  = wf.wf_value;
T   = 2*3.1416/wf;
start = 3;

plotType = 1;
while plotType < 3
    while (prevSam ~= samples)
        prevSam = samples;
        
        %% Get torques
        if (plotType == 0)
            onlineTime = tdfread('../data/onlineTime.txt');
            onlineTime = onlineTime.onlineTime;
            samples    = size(onlineTime,1);
            onlineTime = onlineTime(start:samples);
            
            onlineTau_ref = tdfread('../data/onlineTau_ref.txt', '\t');
            onlineTau_ref = onlineTau_ref.onlineTau_ref;
            onlineTau_ref = onlineTau_ref(start:samples,:);
            pauseTime = 0.1;
        end
        if (plotType == 1)
            onlineTime = tdfread('../data/onlineTime.txt');
            onlineTime = onlineTime.onlineTime;
            samples    = size(onlineTime,1);
            onlineTime = onlineTime(start:samples);
            
            onlineTau_rbd = tdfread('../data/onlineTau_rbd.txt', '\t');
            onlineTau_rbd = onlineTau_rbd.onlineTau_rbd;
            onlineTau_rbd = onlineTau_rbd(start:samples,:);
            
            onlineTau_non1 = tdfread('../data/onlineTau_non1.txt', '\t');
            onlineTau_non1 = onlineTau_non1.onlineTau_non1;
            onlineTau_non1 = onlineTau_non1(start:samples,:);
            
            pauseTime = 0.25;
        end
        if (plotType == 2)
            onlineTau_pred = tdfread('../data/onlineTau_pred.txt', '\t');
            onlineTau_pred = onlineTau_pred.onlineTau_pred;
            samples = size(onlineTau_pred,1);
            if (samples > maxSamples)
                samples = maxSamples;
            end
            onlineTau_pred = onlineTau_pred(start:samples,:);
            
            onlinekAlpha = tdfread('../data/onlinekAlpha.txt', '\t');
            onlinekAlpha = onlinekAlpha.onlinekAlpha;
            onlinekAlpha = onlinekAlpha(1:samples,:);
            
            onlineTau_non2 = tdfread('../data/onlineTau_non2.txt', '\t');
            onlineTau_non2 = onlineTau_non2.onlineTau_non2;
            onlineTau_non2 = onlineTau_non2(start:samples,:);
            
            pauseTime = 0.5;
        end
        
        %% Plot torques
        rows = 3; cols = 3;
        for i = 1:dof
            subplot(rows, cols, i);
            
            if plotType == 0
                h1=plot(onlineTime, onlineTau_ref(:,i) ,'r'); hold on;
                leg1 = legend(h1,{'$\tau_{ref}$'});
            elseif plotType == 1
                h1=plot(onlineTime, onlineTau_non1(:,i) ,'r'); hold on;
                h2=plot(onlineTime(start:length(onlineTau_rbd)), onlineTau_rbd(start:end,i), 'k');
                leg1 = legend([h1,h2],{'$\tau_{non}$','$\tau_{rbd}$'});
            elseif plotType == 2
                h1=plot(onlineTime(start:length(onlineTau_non2)), onlineTau_non2(start:end,i) ,'r'); hold on;
                %                 h2=plot(onlineTime(start:length(onlineTau_rbd)), onlineTau_rbd(start:end,i),  'g');
                h3=plot(onlineTime(start:length(onlineTau_pred)),onlineTau_pred(start:end,i), 'b');
                %                 h4=plot(onlineTime(start:length(onlinekAlpha)),  onlinekAlpha(start:end,i), 'c');
                leg1 = legend([h1,h3],{'$\tau_{nonGP}$','$\tau_{pred}$'});
            end
            
            grid on;
%             [a, MSGID] = lastwarn();
%             warning('off', MSGID);
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
    figure
end
disp('Completed all plots!');