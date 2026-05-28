# hurst-exponent-meg

This repository contains MATLAB/FieldTrip scripts for an end-to-end workflow to compute the Hurst exponent from MEG virtual channels.

The workflow includes MRI–MEG co-registration, MEG preprocessing, head model and source model construction, LCMV beamforming, virtual electrode extraction, and Hurst Exponent estimation.

Written and maintained by Caroline Witton and [Kirandeep Kaur](https://github.com/kkauraiims).

## Workflow

### 01_ft_coregister_meg_mri.m

Co-registers Elekta Neuromag MEG data with structural MRI and prepares the geometrical and covariance inputs required for source analysis.

Main outputs:
- preprocessed MEG data covariance matrix
- head model
- source model
- figures for checking MRI/headshape/sensor/source-model alignment

Typical runtime: 15–20 minutes per subject.

### 02_ft_compute_virtual_electrodes.m

Performs LCMV beamformer source analysis using the precomputed head model, source model and covariance matrix, then extracts virtual electrode time series.

Main outputs:
- leadfield matrix
- LCMV source output
- virtual electrode time series

Typical runtime: 45–60 minutes per subject.

### 03_ve_compute_hurst.m

Computes the Hurst exponent for each virtual electrode time series.

Main outputs:
- Hurst exponent values for each virtual electrode

## External dependency

This workflow uses the HURST MATLAB function by Rafal Weron:

Weron R. HURST: MATLAB function to compute the Hurst exponent using R/S Analysis. Statistical Software Components M11003, Hugo Steinhaus Center, Wroclaw University of Science and Technology, 2011.

https://ideas.repec.org/c/wuu/hscode/m11003.html

Please download the function separately and add it to your MATLAB path before running `03_ve_compute_hurst.m`.
