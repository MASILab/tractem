function [wcfa,wcdwi,wct1,wcseg,wcgraddev,wcmask] = affine_to_tal( ...
	cfa,cdwi,ct1,cseg,cgraddev,cmask,atlas)

% Use SPM12 Old Normalise to estimate affine transformation of subject FA
% image to Tal FA template

spm_jobman('initcfg')
clear matlabbatch
tag = 0;

% Estimate & Write FA, graddev, dwi, T1
tag = tag + 1;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.source = {cfa};
matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
if isempty(cgraddev)
	matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.resample = ...
		{cfa; cdwi; ct1};
else
	matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.resample = ...
		{cfa; cgraddev; cdwi; ct1};
end
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.template = ...
    {atlas};
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.smoref = 8;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.nits = 0;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.bb = ...
	[-78 -112 -70; 78 76 85];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.vox = [1 1 1];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.interp = 1;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.prefix = 'w';

% Write only for mask and seg using NN interp
tag = tag + 1;
[pth,nam] = fileparts(cfa);
matlabbatch{tag}.spm.tools.oldnorm.write.subj.matname = ...
	{[pth '/' nam '_sn.mat']};
matlabbatch{tag}.spm.tools.oldnorm.write.subj.resample = {cmask; cseg};
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.preserve = 0;
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.bb = ...
	[-78 -112 -70; 78 76 85];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.vox = [1 1 1];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.interp = 0;
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.prefix = 'w';

% Run jobs
spm_jobman('run',matlabbatch)


% Change NaN values to zero in all images so DSI Studio can read them
disp('Replacing NaN with zero')
wcfa = change_nan_with_w(cfa);
wcdwi = change_nan_with_w(cdwi);
wct1 = change_nan_with_w(ct1);
wcseg = change_nan_with_w(cseg);
wcgraddev = change_nan_with_w(cgraddev);
wcmask = change_nan_with_w(cmask);


% Function to change nan to zero
function wfname = change_nan_with_w(fname)
if isempty(fname), wfname = fname; return; end
[pth,nam,ext] = fileparts(fname);
fname = fullfile(pth,['w' nam ext]);
V = spm_vol(fname);
n = numel(V);
for k = 1:n
	Y = spm_read_vols(V(k));
	Y(isnan(Y(:))) = 0;
	spm_write_vol(V(k),Y);
end
[pth,nam,ext] = spm_fileparts(V(1).fname);
wfname = fullfile(pth,[nam ext]);
