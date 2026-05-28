function ve_compute_hurst (patient_id)
%% This function computes the Hurst Exponent (HE) for every virtual electrode (ve) 
% time series generated in 02_ft_compute_virtual_electrodes.m
% Input: 
%      (i) VE for every patient, saved in a folder by the same name as the patient id
%      (ii) the script uses hurst_mod function written by Rafal Weron (2011.09.30) to compute HE, 
%      and requires this function to be in the MATLAB path. 
%      hurst_mod can be downloaded from https://ideas.repec.org/c/wuu/hscode/m11003.html
%      (iii) input files (ve time series) should be in .dat format
% Output: 
%      HE of every ve time series is saved as a separate .txt file with appended ve number
%      the output directory for storing HE outputs is created automatically 
% Notes:   
%      no manual input required 
% Authors: KK; October, 2022

% addpath to the hurst_mod script 
addpath '/Path/to/hurst_mod'

% path to patient directory 
patient_dir = strcat ('/Path/to/', patient_id, '/time_series');
cd (patient_dir)

% load virtual electrode time_series 
ve_files = dir ('*.dat');

% Create a directory for storing the Hurst output 
he_output_dir= strcat('path/to/he_output/', patient_id);
mkdir(he_output_dir)

% run the hurst_mod script and save the output to a text file
tic
 for i = 1: length (ve_files)
     ve = load (ve_files(i).name);
     [~,~,H,~] = hurst_mod(ve(2,:),50); % use hurst_mod function to calculate H 
     H_idx = extractBetween(ve_files(i).name, "_", ".dat"); % extract the index of the time series 
     % create a file name including the index of the ve time series for
     % which the Hurst Exponent was derived
     fname = [he_output_dir, 'H_', H_idx{1,1} , '.txt']; 
     % save H of every time series as a separate .txt file with appended ve number
     save (fname, 'H', '-ascii') 
     close all
     clear ve % clean variable data to save computer memory
 end 
 toc
