# hurst_exponent_meg
This repository contains a set of scripts for pre-processing, beamforming and hurst exponent analysis of magnetoencephalography data in FieldTrip (MATLAB)
Description: 

# coregister_ft_he_kk 
This is a custom function to co-register Elekta MEG data with individual MRI. This serves as the first step in computing the Hurst Exponent for every MRI co-registered virtual electrode in MEG
-requires manual input
-currently coded for '.mgz' MRI files only (can be changed for other file types as needed) 
-typical run time - 15-20 minutes/ subject 
-KK, June 2022; updated- Oct, 2022

# he_ft_kk
This is a custom function to write virtual electrode time-series from an already created source model. It can be implemented in continuation with
coregister_ft_kk. 
-no manual inputs required
-input files - sourcemodel.mat 
- KK, July, 2022, updated- Oct, 2022

