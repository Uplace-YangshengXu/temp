% modified in 15/01/2023 by yangshengxu

clear;
clc;
% correct least square method for FBG calibration
% this version don't take mean value of trials
num_CH = 3;
num_AA = 4;
num_trial_1 = 1:1:5;
num_trial_2 = 1:1:5; 
namefile1 = "calibration.xls";
namefile2 = "validation.xls";

index = []; % record index of each AA (each row has num_CH values)
measure_mat = []; % trial of 0 deg, trial of 90 deg
curvature1 = [0,0.5,1.6,2.0,2.5,3.2,4.0]; % constant curvature curve for calibration.xls
curvature2 = [0,0.25,0.8,1.0,1.25,3.125]'; % for validation.xls
real_mat = []; % correspoding curvature for measure_mat

num_point = 200;

ifcombine_c_v = 0;

% construct of real_mat
curvature = curvature1;
for i = 1:size(curvature,2)
    row_real_mat = [];
    for j = 1:num_AA
        add = [];
        for k = num_trial_1
            for h = 1:num_point
                add = [add; curvature(i) 0];
            end
        end
        for k = num_trial_1
            for h = 1:num_point
                add = [add; 0 curvature(i)];
            end
        end
        row_real_mat = [row_real_mat add];
    end
    real_mat = [real_mat; row_real_mat];
end

if ifcombine_c_v == 1
    curvature = curvature2;
    for i = 1:size(curvature,2)
        row_real_mat = [];
        for j = 1:num_AA
            add = [];
            for k = num_trial_2
                %for h = 1:200
                    add = [add; curvature(i) 0];
                %end
            end
            for k = num_trial_2
                %for h = 1:200
                    add = [add; 0 curvature(i)];
                %end
            end
            row_real_mat = [row_real_mat add];
        end
        real_mat = [real_mat; row_real_mat];
    end
end


for i = 1:num_AA
    index = [index i:num_AA:num_CH*num_AA];
end

% get measure_mat
% read data from calibration.xls
curvature = curvature1;
namefile = namefile1;
for i = 1:size(curvature,2) % five curves (excluding straight)
    curve = num2str(curvature(i));
    trial_0d = [];
    trial_90d = [];
    % temp compensation
    for tri = num_trial_1
        % get reference reading
        sheet_name_unbent = strcat('trial',num2str(tri),'_0mm'); 
        fbg_unbent_0d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_0deg'));
        fbg_unbent_90d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_90deg'));
    
        sheet_name = strcat('trial',num2str(tri),'_',curve,'mm'); 
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg')) - fbg_unbent_0d;
        fbg_curve_0d = data(:,index);
        
        %trial_0d = [trial_0d ; mean(fbg_curve_0d,1)]; % dim: 1*numAA*numCH
        trial_0d = [trial_0d ; fbg_curve_0d]; % dim: 200*numAA*numCH
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_90deg')) - fbg_unbent_90d;
        fbg_curve_90d = data(:,index);
        %trial_90d = [trial_90d ; mean(fbg_curve_90d,1)];
        trial_90d = [trial_90d ; fbg_curve_90d];
    end
    % construct measrue_mat
    % disp(trial_0d);
    measure_mat = [measure_mat; trial_0d; trial_90d];
end

if ifcombine_c_v == 1
    % read data from validation.xls
    curvature = curvature2;
    namefile = namefile2;
    for i = 1:size(curvature,2) % five curves (excluding straight)
        curve = num2str(curvature(i));
        trial_0d = [];
        trial_90d = [];
        % temp compensation
        for tri = num_trial_2
            % get reference reading
            sheet_name_unbent = strcat('trial',num2str(tri),'_0mm'); 
            fbg_unbent_0d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_0deg'));
            fbg_unbent_90d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_90deg'));
        
            sheet_name = strcat('trial',num2str(tri),'_',curve,'mm'); 
            data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg')) - fbg_unbent_0d;
            fbg_curve_0d = data(:,index);
            
            %trial_0d = [trial_0d ; mean(fbg_curve_0d,1)]; % dim: 1*numAA*numCH
            trial_0d = [trial_0d ; fbg_curve_0d];
            data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_90deg')) - fbg_unbent_90d;
            fbg_curve_90d = data(:,index);
            %trial_90d = [trial_90d ; mean(fbg_curve_90d,1)];
            trial_90d = [trial_90d ; fbg_curve_90d];
        end
        % construct measrue_mat
        % disp(trial_0d);
        measure_mat = [measure_mat; trial_0d; trial_90d];
    end
end
% End of data loading

% disp(measure_mat);

% the dim of measure_mat should be 2*(5+4)*num_curve * (numAA*numCH)
% disp(size(measure_mat)); % 90 * 8 
% with format curvature1_0: AA1_ch1 AA1_ch2 ... AA2_ch1 ...
%             curvature1_90:
% ...

AA_index = [];
Hsub_index = [];
for i = 1:num_AA
    AA_index = [AA_index; num_CH*(i-1) + 1 : num_CH*i];
    Hsub_index = [Hsub_index; (num_CH+1)*(i-1) + 1 : (num_CH+1)*i];
end


%% least square get calibration matrix H
H = zeros((num_CH + 1)*num_AA, 2*num_AA);
Y_assem = [];
for i = 1:num_AA
    Y = [ones(size(measure_mat, 1), 1), measure_mat(:, AA_index(i,:))];
    R = real_mat(:, (2*i - 1): 2*i);
    H_sub = inv(transpose(Y)*Y)*transpose(Y)*R;
    H(Hsub_index(i,:),(2*i - 1): 2*i) = H_sub;
    Y_assem = [Y_assem, Y];
end

% H = pinv([ones(size(measure_mat,1),1) measure_mat]' * [ones(size(measure_mat,1),1) measure_mat]) * [ones(size(measure_mat,1),1) measure_mat]' * real_mat;
%disp(H);
%disp(size(H)); % 9 * 8

% get the error of least square
predict = Y_assem * H;
error = predict - real_mat;
%disp(size(error));
%disp(error); % looks good!
disp(mean(abs(error),1)); % average abs error for channels in each AA

% then apply the calibration matrix to validation data
save('Cal_mat_3CH_nomean.mat','H');
%save('Cal_mat_3CH_nomean_alldata.mat','H');