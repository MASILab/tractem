% Transform FSL's JHU FA atlas image from MNI to Tal space using Lancaster
% 2007 affine transformation.
V = spm_vol('JHU-ICBM-FA-2mm.nii');
Y = spm_read_vols(V);
icbm_pooled = [
	0.9357 0.0029 -0.0072 -1.0423
	-0.0065 0.9396 -0.0726 -1.394
	0.0103 0.0752 0.8967 3.6475
	0.0000 0.0000  0.0000  1.0000
	];
V.fname = 'JHU-ICBM-FA-2mm-TAL.nii';
V.mat = icbm_pooled * V.mat;
spm_write_vol(V,Y);

% Now use coreg write to get this back into a square space
clear matlabbatch
matlabbatch{1}.spm.spatial.coreg.write.ref = {'JHU-ICBM-FA-2mm.nii'};
matlabbatch{1}.spm.spatial.coreg.write.source = {'JHU-ICBM-FA-2mm-TAL.nii'};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
spm_jobman('run',matlabbatch)


