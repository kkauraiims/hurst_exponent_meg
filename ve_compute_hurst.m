function ve_compute_hurst (patient_id)
%% This is a custom function to compute the Hurst Exponent for every 
% virtual electrode (ve) time series generated in previous codes
% no manual input required 
% input files- ve time series in .dat format

% KK, October, 2022, updated December, 2022

addpath '/Users/neelbazro/Desktop/HE/hurst_scripts'
 
patient_dir = strcat ('/Users/neelbazro/Desktop/he_db/output','/', patient_id, '/time_series');
cd (patient_dir)

%% load virtual electrode time_series 
ve_files = dir ('*.dat');

%% Create a directory for storing the Hurst output 
mkdir(strcat('/Users/neelbazro/Desktop/he_db/output','/', patient_id, '/H'))

%% run the hurst_mod script and save the output to a text file

tic
 for i = 1: length (ve_files)
     ve = load (ve_files(i).name);
     [~,~,H,~] = hurst_mod(ve(2,:),50); % use hurst_mod function to calculate H 
     H_idx = extractBetween(ve_files(i).name, "_", ".dat"); % extract the index of the time series 
     % create a file name including the index of the ve time series for
     % which the Hurst Exponent was derived
     fname = ['/Users/neelbazro/Desktop/he_db/output/' patient_id, '/H/', 'H_', H_idx{1,1} , '.txt']; 
     % save H of every time series as a separate .txt file with appended ve number
     save (fname, 'H', '-ascii') 
     close all
     clear ve % clean variable data to save computer memory
 end 
 toc
     
     
     
     
     
     
     
     
     
     
     
     
     







