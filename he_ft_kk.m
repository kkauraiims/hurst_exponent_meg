function he_ft_kk (patient_id) 
%% This is a custom function to perform beamforming kurtosis from an already 
% created source model. It can be implemented in continuation with
% coregister_ft_kk. This function 
% no manual inputs required
% input files - sourcemodel.mat 

% KK, July, 2022

patient_dir = strcat ('/Users/neelbazro/Desktop/he_db/output', '/', patient_id);

cd (patient_dir)

load sourcemodel.mat 

%% compute leadfield 
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

%% %plot svd of covariance matrix 

[u,s,v] = svd(cov_matrix.cov);

figure;
semilogy(diag(s),'o-');
savefig (gcf, 'svd_covariance.fig', 'compact');  
close all
%% compute the LCMV beamformer 

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
       
%% interpolate kurtosis into the mri 
cfg = [];
cfg.parameter = 'kurtosis';
source_interp = ft_sourceinterpolate(cfg, source, mri_realigned);

%% load brainnetome atlas
atlas_brainnetome = ft_read_atlas ('/Users/neelbazro/Desktop/HE/fieldtrip-20220104/template/atlas/brainnetome/BNA_MPM_thr25_1.25mm.nii');

%% plot kurtosis output in 'ortho'
cfg = [];
cfg.funparameter = 'kurtosis';
cfg.method = 'ortho'; % orthogonal slices with crosshairs at peak (default anyway if not specified)
cfg.atlas = atlas_brainnetome; 
ft_sourceplot(cfg, source_interp);
%% plot kurtosis output in 'slices'
cfg = [];
cfg.funparameter = 'kurtosis';
cfg.method = 'slice'; % plot slices
ft_sourceplot(cfg, source_interp);
%% find regions of max kurtosis

array = reshape(source.avg.kurtosis, source.dim);
array(isnan(array)) = 0;
ispeak = imregionalmax(array); % findpeaksn is an alternative that does not require the image toolbox
peakindex = find(ispeak(:));
[peakval, i] = sort(source.avg.kurtosis(peakindex), 'descend'); % sort on the basis of kurtosis value
peakindex = peakindex(i);

npeaks = 5;
disp(source.pos(peakindex(1:npeaks),:));% output positions
poi = (source.pos(peakindex(1:npeaks),:));

%% plot peaks 

for i = 1:npeaks
  cfg = [];
  cfg.funparameter = 'kurtosis';
  cfg.location = source.pos(peakindex(i),:)*1000; % convert from m to mm
  cfg.atlas = atlas_brainnetome; 
  ft_sourceplot(cfg, source_interp);
  savefig (gcf, strcat ('kurtosis','_atlas','_',num2str (i), '.fig'), 'compact');
end 
close all
%% visualize the kurtosis in MRIcro 

cfg = [];
cfg.filename = strcat (patient_id, '.nii');
cfg.parameter = 'anatomy';
cfg.format = 'nifti';
ft_volumewrite(cfg, source_interp);

cfg = [];
cfg.filename = strcat(patient_id, '_kurtosis.nii');
cfg.parameter = 'kurtosis';
cfg.format = 'nifti';
cfg.datatype = 'float'; % integer datatypes will be scaled to the maximum, floating point datatypes not
ft_volumewrite(cfg, source_interp);

%% write vm timeseries

for i = 1: length (source.avg.mom); 
    if isempty (source.avg.mom{i,1}) == 0
        ve_series = source.avg.mom {i,1};
        ve_matrix = [source.time; ve_series];
        fname = ['/Users/neelbazro/Desktop/he_db/output/', patient_id, '/time_series', '/', 've' '_', num2str(i) , '.dat'];
        % patient_id already specified for the beamformer_ft_kk function
        % Specifies the subject for which the script is being run
        save (fname, 've_matrix', '-ascii')
    end 
end 
        
