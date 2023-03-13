% created by Yangsheng Xu at Mar. 12 2023
% this script is used to generate calibration matrix for FBG needle 0006
% base on data set calibration7-9_090.xls, calibration10-12_090.xls,
% validation7-9.xls and validation10-12.xls.

% the method used in this script is exactly the same as in
% Cal_mat_SeperateAA.m, but script use only 89% data set.

% this script is highly customized, not suitable for auto calibration
% matrix generation

clear;
clc;

num_CH = 2; % only 2 channels were used
num_AA = 4;
trial_num = {7:9,10:12}; % each data file store 3 trials of measurement for 6 curves
calibration_filename = {'calibration7-9_090.xls','calibration10-12_090.xls'};
validation_filename = {'validation7-9_090.xls','validation10-12_090.xls'};
cali_curve_curvature = [0,0.5,1.6,2.0,2.5,3.2];
vali_curve_curvature = [0,0.25,0.8,1.0,1.25,3.125];

% data selection
cali_ch1_deg0 = {[1:6],
            [1:6],
            [1:6],
            [1:6]};
cali_ch1_deg90 = {[1:6],
            [1:6],
            [1:6],
            [1,2,4,5,6]};
        
 cali_ch2_deg0 = {[1,3],
            [1,2,3,5,6],
            [1,2,3,4,6],
            [1,2,6]};
 
 cali_ch2_deg90 = {[1:6],
            [1:6],
            [1:6],
            [1:6]};
        
 vali_ch1_deg0 = {[1:6],
            [1:6],
            [1:6],
            [1,3,4,5,6]};
 
 vali_ch1_deg90 = {[1:6],
            [1:6],
            [1:6],
            [1,2,5,6]};
 
 vali_ch2_deg0 = {[1,6],
            [1,3,4,5,6],
            [1,3,4,6],
            [1,2,3,4,6]};
 
 vali_ch2_deg90 = {[1:6],
            [1:6],
            [1:6].
            [1:6]};

            

%output filename
cal_name = 'Cal_mat_2CH_alldata.mat';

%% construct meassured data matrix and expected data matrix
real_mat = [];
measrue_mat = [];

for i = 1:num_AA
    % first cal ch1_ch2 deg 0
    
    
