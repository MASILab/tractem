function wb_table = b_vec_transformation(bval,bvec,snmat)

sn = load(snmat);
bvecs = load(bvec);
bvals = load(bval);

% Compute the actual affine transform by appropriately combining the
% voxel-to-mm matrices of the two images and the sn.Affine matrix
%
% From spm_normalise.m line 183
% 
%   VF is subject image, VG is atlas
%
%   Affine     = inv(VG(1).mat\M*VF1(1).mat);
% thus,
%   Affine     = inv( inv(VG(1).mat)*M*VF1(1).mat );
%   inv(Affine) = inv(VG(1).mat)*M*VF1(1).mat ;
%   inv(Affine)*inv(VFmat) = inv(VG(1).mat)*M ;
%   VG.mat*inv(Affine)*inv(VF.mat) = M;
%   VG.mat/Affine/VF.mat = M;
%
% But if the norm of the bvec is zero, just set the output to zero (used to
% indicate a non-diffusion weighted image)
M = sn.VG.mat / sn.Affine / sn.VF.mat;
for k=1:length(bvecs)
	tal_bvecs(:,k) = M(1:3,1:3) * bvecs(:,k);
	if norm(tal_bvecs(:,k)) ~= 0
		tal_bvecs(:,k) = tal_bvecs(:,k) ./ norm(tal_bvecs(:,k));
	else
		tal_bvecs(:,k) = tal_bvecs(:,k);
	end
end

% Must follow format: bvalue, bx, by, bz
b_table = [bvals; tal_bvecs]';

% Save b table as text file
pth = fileparts(bvec);
wb_table = [pth '/wb_table.txt'];
fid = fopen(wb_table,'wt');
for k = 1:size(b_table,1)
	fprintf(fid,'%0.2f %0.6f %0.6f %0.6f\n',b_table(k,:));
end
fclose(fid);
