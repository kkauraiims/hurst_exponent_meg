function ve_compute_hurst (patient_id)
%% This is a custom function to compute the Hurst Exponent for every 
% virtual electrode (ve) time series generated in previous codes
% no manual input required 
% input files- ve time series in .dat format

% KK, October, 2022

addpath '/Users/neelbazro/Desktop/HE'
 
patient_dir = strcat ('/Users/neelbazro/Desktop/he_db/output','/', patient_id, '/time_series');
cd (patient_dir)

%% load virtual electrode time_series 
ve_files = dir ('*.dat');

 for i = 1: length (ve_files)
     ve = load (ve_files(i).name);
     [d,RSe,H,a] = hurst_mod(ve(2,:),50); % use hurst_mod function to calculate H 
     fname = ['/Users/neelbazro/Desktop/he_db/output/' patient_id, '/H/', 'H_' num2str(i) , '.txt']; 
     save (fname, 'H', '-ascii')
     close all
 end 
     
     
     
     
     
     
     
     
     
     
     
     
     







