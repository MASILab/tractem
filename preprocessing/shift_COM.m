function [cfa,cdwi,ct1,cseg,cgraddev,cmask] = shift_COM( ...
	fa,dwi,t1,seg,graddev,mask,atlas)

% Align center of mass of a set of images to the JHU template. Base this on
% the FA image, and assume all the other images have the same geometry and
% can just be brought along.

% Find image centers of mass
tgt_com = find_center_of_mass(atlas);
src_com = find_center_of_mass(fa);
     
% How to move the subject images
src_shift = tgt_com - src_com;
src_shift_mat = spm_matrix(src_shift);

% Do the shift
cfa = shift(fa,src_shift_mat);
cdwi = shift(dwi,src_shift_mat);
ct1 = shift(t1,src_shift_mat);
cseg = shift(seg,src_shift_mat);
cgraddev = shift(graddev,src_shift_mat);
cmask = shift(mask,src_shift_mat);


% Subfunctions we use

function cfname = shift(imfile,src_shift_mat)
if isempty(imfile), cfname = imfile; return, end
V = spm_vol(imfile);
n = numel(V); 
Y = spm_read_vols(V);
for k = 1:n
	[pth,nam,ext,num] = spm_fileparts(V(k).fname);
	V(k).fname = [pth '/c' nam ext num];
	V(k).mat = src_shift_mat * V(k).mat;
	spm_write_vol(V(k),Y(:,:,:,k));
end
[pth,nam,ext] = spm_fileparts(V(1).fname);
cfname = fullfile(pth,[nam ext]);

