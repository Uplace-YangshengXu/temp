% modified in 15/01/2023 by yangshengxu
% this script collect fbg reading data for calibration
clear;
clc;
addpath ../../../../sm130_interrogator_matlab/
% collect 200 data set for each curve
FBG_data_point = 400;
%
val_repetitions = 2;
% number of channle and activate area
channels = 3;
AAs = 4;

% curvature of slots on jig
% cal_curve = [0,0.5,1.6,2.0,2.5,3.2,4.0]';
% slot_num = length(cal_curve);
% filename = '/calibration_ch1.xls';

% % curvature of slots on jig
cal_curve = [0,0.25,0.8,1.0,1.25,3.125]';
slot_num = length(cal_curve);
filename = '/validation_ch1.xls';


cal_rot = [90,270];
calPath = cd;

% run ini_interrogator.m
interrogator = ini_interrogator('IPaddress','192.168.1.11','Port',1852,'ReadTimeout',0.1);


for k = 1:val_repetitions
    for i = 1:slot_num
        for n = 1:length(cal_rot)
            clc;
            txt = strcat('slot no.',num2str(i),',  ',num2str(cal_rot(n)), ' deg, trial ',num2str(k));
            disp(txt);
            disp('Press Enter when ready to collect data');
            pause;
            
            cal_data = Read_interrogator(FBG_data_point,channels,AAs,interrogator);
            absfileName = strcat(calPath,filename);
            sheetName = strcat('trial',num2str(k),'_',num2str(cal_curve(i)),'mm','_',num2str(cal_rot(n)),'deg');
            writematrix(cal_data,absfileName,'sheet',sheetName);

        end
    end
end

close_pnet();
