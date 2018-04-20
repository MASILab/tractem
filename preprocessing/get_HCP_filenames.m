function [zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs] = get_HCP_filenames(hcp_dir)

% Given a directory where an HCP preprocessed DWI image set (e.g.
% nnnnnn_3T_Diffusion_preproc.zip) was unzipped, get the filenames of the
% relevant files for diffusion processing.

zt1 = [hcp_dir '/T1w/T1w_acpc_dc_restore_1.25.nii.gz'];
zseg = [hcp_dir '/T1w/T1w_acpc_dc_restore_1.25_seg.nii.gz'];
zdwi = [hcp_dir '/T1w/Diffusion/data.nii.gz'];
zmask = [hcp_dir '/T1w/Diffusion/nodif_brain_mask.nii.gz'];
zgrad = [hcp_dir '/T1w/Diffusion/grad_dev.nii.gz'];
bvals = [hcp_dir '/T1w/Diffusion/bvals'];
bvecs = [hcp_dir '/T1w/Diffusion/bvecs'];
