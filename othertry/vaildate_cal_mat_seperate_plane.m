clear;
clc;
% create in 17/01/2023 by yangsheng xu
% try to validate the approach to seperate xy and xz plane but the result is not good.

% load Cal_mat_2CH.mat % calibration matrix get from calibration.xlsx
% load Cal_mat_2CH_v2.mat 
% the difference between Cal_mat_2CH.mat and Cal_mat_2CH_v2.mat is that:
% the previous one take mean value of trials
% the Cal_mat_2CH_alldata.mat use both data in calibration.xls and validation.xls


addpath ../
load Cal_mat_3CH_seperate.mat % for 3 channel needle
num_CH = 3; % !!! when change the variable make sure line 117 and 127 is consistant with the channel number !!!


num_AA = 4;
num_trial_1 = 1:1:5; % for calibration.xls
num_trial_2 = 1:1:5; % for validation.xls exclude stright line

namefile = 'validation.xls'; % data used to validate the calibration matrix
num_trial = num_trial_2;
curvature = [0,0.25,0.8,1.0,1.25,3.125]; % constant curvature curve


index = []; % record index of each AA (each row has num_CH values)


real_mat = []; % correspoding curvature for measure_mat
sum_error_AAs = zeros(1,num_AA);
data_count = 0;
for i = 1:num_AA
    index = [index i:num_AA:num_CH*num_AA];
end


fig = figure('Name','validation');
set(fig, 'Position', [60, 515, 1750, 450]);
%ax = axes('Parent',fig);
subax1 = subplot(2,2,1);
subax2 = subplot(2,2,2);
subax3 = subplot(2,2,3);
subax4 = subplot(2,2,4);

txt = num2str(curvature(1));
for i = 2 : size(curvature,2)
    txt = sprintf('%s, %s',txt, num2str(curvature(i)));
end
title_str1 = sprintf('XY plane: Desire curvature: %s',txt);
title_str2 = sprintf('XZ plane: Desire curvature: %s',txt);
output_txt = sprintf('Average abs error for AAs(curvature, %s)',txt);
title(subax1,title_str1);
title(subax4,'XY plane: Desire curvature: 0');
title(subax3,title_str2);
title(subax2,'XZ plane: Desire curvature: 0');
ylabel(subax1,'curvature');
ylabel(subax2,'curvature');
ylabel(subax3,'curvature');
ylabel(subax4,'curvature');
xlabel(subax1,'count');
xlabel(subax2,'count');
xlabel(subax3,'count');
xlabel(subax4,'count');
hold(subax1,'on');
hold(subax3,'on');
hold(subax2,'on');
hold(subax4,'on');

color_type = ['r','b','k','g','y','m','c']; % color for different curvature

for i = 1:size(curvature,2) % four curves (excluding straight)
    
    curve = num2str(curvature(i));
    cl = color_type(i);
    % temp compensation
    for tri = num_trial
        % get reference reading
        sheet_name_unbent = strcat('trial',num2str(tri),'_0mm'); 
        fbg_unbent_0d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_0deg'));
        fbg_unbent_90d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_90deg'));
    
        sheet_name = strcat('trial',num2str(tri),'_',curve,'mm'); 
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg')) - fbg_unbent_0d;
        fbg_curve_0d = data(:,index);
        one_size = size(fbg_curve_0d, 1);
        
        
        predict_curvature_hori = [ones(one_size, 1) fbg_curve_0d(:, 1:3) ones(one_size, 1) fbg_curve_0d(:, 4:6) ones(one_size, 1) fbg_curve_0d(:, 7:9) ones(one_size, 1) fbg_curve_0d(:, 10:12)] * H_hori;
        
        % only care about curvaure in hori plane
        predict_curvature = predict_curvature_hori;
        plot(subax1,1:size(predict_curvature,1),predict_curvature(:,1),cl);
        plot(subax1,1:size(predict_curvature,1),predict_curvature(:,2),cl);
        error_mat = predict_curvature - [curvature(i) curvature(i) curvature(i) curvature(i)];
        sum_error_AAs = sum_error_AAs + abs(error_mat);
        data_count = data_count + 1;
        plot(subax1,1:size(predict_curvature,1),predict_curvature(:,3),cl);
        plot(subax1,1:size(predict_curvature,1),predict_curvature(:,4),cl);
        predict_curvature_vert = [ones(one_size, 1) fbg_curve_0d(:, 1:3) ones(one_size, 1) fbg_curve_0d(:, 4:6) ones(one_size, 1) fbg_curve_0d(:, 7:9) ones(one_size, 1) fbg_curve_0d(:, 10:12)] * H_vert;

        
        plot(subax2,1:size(predict_curvature,1),predict_curvature_vert(:,1),cl);
        plot(subax2,1:size(predict_curvature,1),predict_curvature_vert(:,2),cl);
        plot(subax2,1:size(predict_curvature,1),predict_curvature_vert(:,3),cl);
        plot(subax2,1:size(predict_curvature,1),predict_curvature_vert(:,4),cl);
%         plot(subax1,1:size(predict_curvature,1),predict_curvature(:,5),cl);
% 
%         plot(subax2,1:size(predict_curvature,1),predict_curvature(:,6),cl);
%         plot(subax1,1:size(predict_curvature,1),predict_curvature(:,7),cl);
% 
%         plot(subax2,1:size(predict_curvature,1),predict_curvature(:,8),cl);

        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_90deg')) - fbg_unbent_90d;
        fbg_curve_90d = data(:,index);
        
        predict_curvature_vert = [ones(one_size, 1) fbg_curve_90d(:, 1:3) ones(one_size, 1) fbg_curve_90d(:, 4:6) ones(one_size, 1) fbg_curve_90d(:, 7:9) ones(one_size, 1) fbg_curve_90d(:, 10:12)] * H_vert;
        % only care about curvaure in vert plane
        predict_curvature = predict_curvature_vert;
        error_mat = predict_curvature - [curvature(i) curvature(i) curvature(i) curvature(i)];
        sum_error_AAs = sum_error_AAs + abs(error_mat);
        data_count = data_count + 1;
        plot(subax3,1:size(predict_curvature,1),predict_curvature(:,1),cl);
        plot(subax3,1:size(predict_curvature,1),predict_curvature(:,2),cl);
        plot(subax3,1:size(predict_curvature,1),predict_curvature(:,3),cl);
        plot(subax3,1:size(predict_curvature,1),predict_curvature(:,4),cl);
        predict_curvature_hori = [ones(one_size, 1) fbg_curve_90d(:, 1:3) ones(one_size, 1) fbg_curve_90d(:, 4:6) ones(one_size, 1) fbg_curve_90d(:, 7:9) ones(one_size, 1) fbg_curve_90d(:, 10:12)] * H_hori;
        plot(subax4,1:size(predict_curvature,1),predict_curvature_hori(:,1),cl);
        plot(subax4,1:size(predict_curvature,1),predict_curvature_hori(:,2),cl);
        plot(subax4,1:size(predict_curvature,1),predict_curvature_hori(:,3),cl);
        plot(subax4,1:size(predict_curvature,1),predict_curvature_hori(:,4),cl);
        
%         plot(subax4,1:size(predict_curvature,1),predict_curvature(:,5),cl);
%         plot(subax3,1:size(predict_curvature,1),predict_curvature(:,6),cl);
%         plot(subax4,1:size(predict_curvature,1),predict_curvature(:,7),cl);
%         plot(subax3,1:size(predict_curvature,1),predict_curvature(:,8),cl);


    end
end


hold(subax1,'off');
hold(subax2,'off');
hold(subax3,'off');
hold(subax4,'off');

% print average abs error
disp(output_txt);
disp(mean(sum_error_AAs./data_count,1));