function com = find_center_of_mass(nifti_file)

% Returns the center of mass in mm coordinates for a nifti file. Useful for
% pre-aligning ahead of SPM coregistration.

V = spm_vol(nifti_file);

[Y,XYZ] = spm_read_vols(V);
 
Y(~isfinite(Y(:))) = 0;

com = (XYZ * (Y(:))/ nansum(Y(:)))';

