function [ct1,cseg] = coregister_t1(dwi,bval,t1,seg)

% Compute b=0 mean image and its COM from DWI
bvals = load(bval);
dind = find(bvals'<10);
dind = cellfun(@num2str,num2cell(dind),'UniformOutput',false);
dwi0 = strcat(dwi,',',dind);
V0 = spm_vol(char(dwi0));
[Y0,XYZ] = spm_read_vols(V0);
Y0(~isfinite(Y0(:))) = 0;
Y0 = mean(Y0,4);
dwi_com = (XYZ * (Y0(:))/ nansum(Y0(:)))';
Vout = rmfield(V0(1),{'pinfo','n','private'});
tgt = fullfile(fileparts(dwi),'dwi_b0_forcoreg.nii');
Vout.fname = tgt;
spm_write_vol(Vout,Y0);

% Compute brain-only T1 image using seg file, and its COM. Write out the
% masked brain for coreg.
Vt1 = spm_vol(t1);
[Yt1,XYZ] = spm_read_vols(Vt1);
Yseg = spm_read_vols(spm_vol(seg));
Yt1(~isfinite(Yt1(:))) = 0;
Yt1(Yseg(:)<4) = 0;
t1_com = (XYZ * (Yt1(:))/ nansum(Yt1(:)))';
Vout = rmfield(Vt1,'pinfo');
[p,n,e] = fileparts(t1);
t1 = fullfile(p,['m' n e]);
Vout.fname = t1;
spm_write_vol(Vout,Yt1);

% How to move the t1/seg images
seg_shift = dwi_com - t1_com;
seg_shift_mat = spm_matrix(seg_shift);

% Apply the shift, creating new files with 'r' prefix
ct1 = shift(t1,seg_shift_mat);
cseg = shift(seg,seg_shift_mat);

% SPM coreg estimate
matlabbatch = [];
tag = 0;
tag = tag + 1;
matlabbatch{tag}.spm.spatial.coreg.estimate.ref = {tgt};
matlabbatch{tag}.spm.spatial.coreg.estimate.source = {ct1};
matlabbatch{tag}.spm.spatial.coreg.estimate.other = {cseg};
matlabbatch{tag}.spm.spatial.coreg.estimate.eoptions = struct( ...
        'cost_fun', 'nmi', ...
        'sep', [4 2], ...
        'tol', [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001], ...
        'fwhm', [7 7] );
spm_jobman('run',matlabbatch)



% Shift function
function cfname = shift(imfile,src_shift_mat)
if isempty(imfile), cfname = imfile; return, end
V = spm_vol(imfile);
n = numel(V); 
Y = spm_read_vols(V);
for k = 1:n
	[pth,nam,ext,num] = spm_fileparts(V(k).fname);
	V(k).fname = [pth '/r' nam ext num];
	V(k).mat = src_shift_mat * V(k).mat;
	spm_write_vol(V(k),Y(:,:,:,k));
end
[pth,nam,ext] = spm_fileparts(V(1).fname);
cfname = fullfile(pth,[nam ext]);
