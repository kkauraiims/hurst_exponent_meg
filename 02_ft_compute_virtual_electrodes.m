function ft_compute_virtual_electrodes (patient_id) 
%% This function computes virtual electrodes (using LCMV beamformer) of MEG data from an already computed:  
% (i) head model (ii) data covariance matrix (iii)source model. 
% This function is implemented in continuation with 01_ft_coregister_meg_mri.m
% Input: 
%       (i) The function only requires the patient/subject id as input
%       (ii) it is assumed that the output directory of 01_ft_coregister_meg_mri.m is the 
%       patient/input directory for this function i.e. the input directory contains the 
%       headmodel, cov_matrix and the sourcemodel 
%       (iii) It is assumed that ft_defaults is already intiated and completed
% Output: 
%       (i) LCMV beamformer source analysis 
%       (ii) Virtual electrodes/ time-series 
% Notes: 
%        no manual inputs required
% Authors: CW, KK; July 2022

% Specify the patient/input directory
patient_dir = strcat ('/Path/to/input_dir/', patient_id);
patient_output_dir = strcat ('/Path/to/output_dir/',patient_id);
cd (patient_dir)

load sourcemodel.mat 

%% compute the leadfield matrix
cfg = [];
cfg.channel = 'MEG';
cfg.headmodel = headmodel;
cfg.sourcemodel = sourcemodel;
cfg.normalize = 'yes'; % normalisation avoids power bias towards centre of head
cfg.reducerank = 2;
cfg.resolution = 2; 
cfg.unit      = 'cm';
leadfield = ft_prepare_leadfield(cfg, cov_matrix);

save ('leadfield'); 

% plot svd of covariance matrix 

[u,s,v] = svd(cov_matrix.cov);

figure;
semilogy(diag(s),'o-');
savefig (gcf, 'svd_covariance.fig', 'compact');  
close all

% compute the LCMV beamformer 
cfg = [];
cfg.method = 'lcmv';
cfg.sourcemodel = leadfield;
cfg.headmodel = headmodel;
cfg.lcmv.keepfilter = 'yes';
cfg.lcmv.fixedori = 'yes'; % project on axis of max variance using SVD
cfg.lcmv.lambda = '5%';
cfg.lcmv.kappa = 69;
cfg.lcmv.projectmom = 'yes'; % project dipole time series in direction of maximal power 
cfg.lcmv.kurtosis = 'yes';
cfg.lcmv.keepmom = 'yes';
source = ft_sourceanalysis(cfg, cov_matrix);

save ('source'); 
       
% write the virtual timeseries
for i = 1: length (source.avg.mom)
    if isempty (source.avg.mom{i,1}) == 0
        ve_series = source.avg.mom {i,1};
        ve_matrix = [source.time; ve_series];
        fname = ['/path/to/output_dir/', '/time_series', '/', 've' '_', num2str(i) , '.dat'];
        % patient_id already specified for the beamformer_ft_kk function
        % Specifies the subject for which the script is being run
        save (fname, 've_matrix', '-ascii')
    end 
end
