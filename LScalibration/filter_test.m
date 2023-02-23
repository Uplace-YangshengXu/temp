% test the effect of Moving average filter
% created in 05/2/2023 by YangshengXu
close all;
num_point = 6000;

% namefile = 'validation.xls'; % data used to validate the calibration matrix
% num_trial = 1:1:5;
% curvature = [0,0.25,0.8,1.0,1.25,3.125]; % constant curvature curve
 
namefile = 'calibration.xls';
num_trial = 1:1:2;
curvature = [0.5 1.6 2 2.5 3.2];

ilustration = figure;
set(ilustration,'position',[10,10,2300,700]);
ax = subplot(1,3,[1 2 3]);
%ax2 = subplot(1,3,2);
%ax3 = subplot(1,3,3);
set(ax,'FontSize',20,'LineWidth',3)
hold(ax,"on")
xlabel(ax,'timestamp')
ylabel(ax,'wavelength')

AA1_ch1_plot = animatedline(ax,'Color','r','LineWidth',3);
AA2_ch1_plot = animatedline(ax,'Color','g','LineWidth',3);
AA3_ch1_plot = animatedline(ax,'Color','b','LineWidth',3);
AA4_ch1_plot = animatedline(ax,'Color','k','LineWidth',3);

% AA1_ch2_plot = animatedline(ax2,'Color','r','LineWidth',3);
% AA2_ch2_plot = animatedline(ax2,'Color','g','LineWidth',3);
% AA3_ch2_plot = animatedline(ax2,'Color','b','LineWidth',3);
% AA4_ch2_plot = animatedline(ax2,'Color','k','LineWidth',3);
% 
% AA1_ch3_plot = animatedline(ax3,'Color','r','LineWidth',3);
% AA2_ch3_plot = animatedline(ax3,'Color','g','LineWidth',3);
% AA3_ch3_plot = animatedline(ax3,'Color','b','LineWidth',3);
% AA4_ch3_plot = animatedline(ax3,'Color','k','LineWidth',3);

legend(ax,'AA1','AA2','AA3','AA4')
% legend(ax2,'AA1','AA2','AA3','AA4')
% legend(ax3,'AA1','AA2','AA3','AA4')
title(ax,'FBG reading')
% title(ax2,'FBG reading for ch2')
% title(ax3,'FBG reading for ch3')

% focus on CH1 AA1 1546 - 1547
%ylim(ax,[1546 1547])


% collect all the data
trial_0d = []; % only consider the data with 0deg
for i = 1:size(curvature,2) % for all curves
    curve = num2str(curvature(i));
    % temp compensation
    for tri = num_trial
        sheet_name = strcat('trial',num2str(tri),'_',curve,'mm');
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg'));
        trial_0d = [trial_0d ; data]; % dim: 1*numAA*numCH

    end
end

% get the dimension of data
[row,col] = size(trial_0d);
timestamp = 1;

while(timestamp <= row)
    cal_data = trial_0d(timestamp,:);
    if timestamp < num_point
        xlim(ax,[0 num_point-1])
    else
        xlim(ax,[timestamp - num_point + 1 timestamp])
    end
    

    % in form of ch1AA1 ch1AA2 ch1AA3 ...
    addpoints(AA1_ch1_plot,timestamp,cal_data(8))
    %addpoints(AA2_ch1_plot,timestamp,cal_data(2))
    %addpoints(AA3_ch1_plot,timestamp,cal_data(3))
    %addpoints(AA4_ch1_plot,timestamp,cal_data(4))

%     addpoints(AA1_ch2_plot,timestamp,cal_data(5))
%     addpoints(AA2_ch2_plot,timestamp,cal_data(6))
%     addpoints(AA3_ch2_plot,timestamp,cal_data(7))
%     addpoints(AA4_ch2_plot,timestamp,cal_data(8))
%     addpoints(AA1_ch3_plot,timestamp,cal_data(9))
%     addpoints(AA2_ch3_plot,timestamp,cal_data(10))
%     addpoints(AA3_ch3_plot,timestamp,cal_data(11))
%     addpoints(AA4_ch3_plot,timestamp,cal_data(12))

    timestamp = timestamp + 1;
    %pause(0.01)
end