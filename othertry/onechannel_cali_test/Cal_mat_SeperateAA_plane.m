% modified in 17/01/2023 by yangshengxu
% this script is an extension of cal_mat_seperateAA.m
% this script try to seperate the calibration matrix of xy and xz plane (0
% and 90 deg)
clear;
clc;
% correct least square method for FBG calibration
% this version don't take mean value of trials
num_CH = 3;
num_AA = 4;

num_trial_1 = 1:1:2; 
%num_trial_2 = 1:1:5; 
namefile1 = "calibration.xls";
%namefile2 = "validation.xls";

index = []; % record index of each AA (each row has num_CH values)
measure_mat_hori = []; % trial of 0 deg, 
measure_mat_vert = []; %trial of 90 deg
curvature1 = [0,0.5,1.6,2.0,2.5,3.2,4.0]; % constant curvature curve for calibration.xls
%curvature2 = [0,0.25,0.8,1.0,1.25,3.125]'; % for validation.xls

real_mat_hori = []; % correspoding curvature for measure_mat in hori plane
real_mat_vert = []; % do not consider vert curvature

ifcombine_c_v = 0;

% construct of real_mat
curvature = curvature1;
for i = 1:size(curvature,2)
    row_real_mat = [];
    for j = 1:num_AA
        add = [];
        for k = num_trial_1
            %for h = 1:200
                add = [add; curvature(i);-curvature(i)];
            %end
        end
        row_real_mat = [row_real_mat add];
    end
    real_mat_hori = [real_mat_hori; row_real_mat];
    %real_mat_vert = [real_mat_vert; row_real_mat];
end

% the dimension of real_mat_hori/vert should be num_curve*num_trial * 4


if ifcombine_c_v == 1
    curvature = curvature2;
    for i = 1:size(curvature,2)
        row_real_mat = [];
        for j = 1:num_AA
            add = [];
            for k = num_trial_2
                %for h = 1:200
                    add = [add; curvature(i)];
                %end
            end
            row_real_mat = [row_real_mat add];
        end
        real_mat_hori = [real_mat_hori; row_real_mat];
        real_mat_vert = [real_mat_vert; row_real_mat];
    end
end

% add more data to real_mat_hori/vert

for i = 1:num_AA
    index = [index i:num_AA:num_CH*num_AA];
end

% get measure_mat
% read data from calibration.xls
curvature = curvature1;
namefile = namefile1;
for i = 1:size(curvature,2) % five curves (excluding straight)
    curve = num2str(curvature(i));
    trial_90d = [];
    trial_270d = [];
    % temp compensation
    for tri = num_trial_1
        % get reference reading
        sheet_name_unbent = strcat('trial',num2str(tri),'_0mm'); 
        fbg_unbent_0d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_0deg'));
        fbg_unbent_90d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_90deg'));
    
        sheet_name = strcat('trial',num2str(tri),'_',curve,'mm'); 
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg')) - fbg_unbent_0d;
        fbg_curve_90d = data(:,index);
        
        %trial_90d = [trial_90d ; mean(fbg_curve_90d,1)]; % dim: 1*numAA*numCH
        %trial_90d = [trial_90d ; fbg_curve_90d]; % dim: 200*numAA*numCH
        data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_90deg')) - fbg_unbent_90d;
        fbg_curve_270d = data(:,index);
        %trial_270d = [trial_270d ; mean(fbg_curve_270d,1)];
        %trial_270d = [trial_270d ; fbg_curve_270d];
        trial_90d = [trial_90d;mean(fbg_curve_90d,1);mean(fbg_curve_270d,1)];
    end
    % construct measrue_mat
    % disp(trial_90d);
    measure_mat_hori = [measure_mat_hori; trial_90d];
    %measure_mat_vert = [measure_mat_vert; trial_270d];
end

if ifcombine_c_v == 1
    % read data from validation.xls
    curvature = curvature2;
    namefile = namefile2;
    for i = 1:size(curvature,2) % five curves (excluding straight)
        curve = num2str(curvature(i));
        trial_90d = [];
        trial_270d = [];
        % temp compensation
        for tri = num_trial_2
            % get reference reading
            sheet_name_unbent = strcat('trial',num2str(tri),'_0mm'); 
            fbg_unbent_0d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_0deg'));
            fbg_unbent_90d = readmatrix(namefile,'Sheet',strcat(sheet_name_unbent,'_90deg'));
        
            sheet_name = strcat('trial',num2str(tri),'_',curve,'mm'); 
            data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_0deg')) - fbg_unbent_0d;
            fbg_curve_90d = data(:,index);
            
            %trial_90d = [trial_90d ; mean(fbg_curve_90d,1)]; % dim: 1*numAA*numCH
            %trial_90d = [trial_90d ; fbg_curve_90d];
            data = readmatrix(namefile,'Sheet',strcat(sheet_name,'_90deg')) - fbg_unbent_90d;
            fbg_curve_270d = data(:,index);
            %trial_270d = [trial_270d ; mean(fbg_curve_270d,1)];
            %trial_270d = [trial_270d ; fbg_curve_270d];
            trial_90d = [trial_90d;mean(fbg_curve_90d,1);mean(fbg_curve_270d,1)];
        end
        % construct measrue_mat
        % disp(trial_90d);
        measure_mat_hori = [measure_mat_hori; trial_90d];
        %measure_mat_vert = [measure_mat_vert; trial_270d];
    end
end


AA_index = [];
Hsub_index = [];
for i = 1:num_AA
    AA_index = [AA_index; num_CH*(i-1) + 1 : num_CH*i];
    Hsub_index = [Hsub_index; (num_CH+1)*(i-1) + 1 : (num_CH+1)*i];
end


%% least square get calibration matrix H_hori and H_vert

H_hori = zeros((num_CH + 1)*num_AA, num_AA);
Y_assem_hori = [];
for i = 1:num_AA
    Y = [ones(size(measure_mat_hori, 1), 1), measure_mat_hori(:, AA_index(i,:))];
    R = real_mat_hori(:, i);
    H_sub = inv(transpose(Y)*Y)*transpose(Y)*R;
    H_hori(Hsub_index(i,:),i) = H_sub;
    Y_assem_hori = [Y_assem_hori, Y];
end

H_vert = zeros((num_CH + 1)*num_AA, num_AA);
% Y_assem_vert = [];
% for i = 1:num_AA
%     Y = [ones(size(measure_mat_vert, 1), 1), measure_mat_vert(:, AA_index(i,:))];
%     R = real_mat_vert(:, i);
%     H_sub = inv(transpose(Y)*Y)*transpose(Y)*R;
%     H_vert(Hsub_index(i,:),i) = H_sub;
%     Y_assem_vert = [Y_assem_vert, Y];
% end



% get the error of least square
% for hori plane (90 deg)
predict = Y_assem_hori * H_hori;
error = predict - real_mat_hori;
disp(mean(abs(error),1)); % average abs error for channels in each AA

% for vert plane (90 deg)
% predict = Y_assem_vert * H_vert;
% error = predict - real_mat_vert;
% disp(mean(abs(error),1));

% then apply the calibration matrix to validation data
save('Cal_mat_3CH_seperate.mat','H_hori','H_vert');
%save('Cal_mat_3CH_seperate_alldata.mat','H_hori','H_vert');