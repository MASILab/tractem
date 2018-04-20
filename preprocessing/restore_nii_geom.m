function dti_fa0 = restore_nii_geom(mask,dti_fa0)

% Restore correct geometry to FA image after DSI studio mangles it.

Vmask = spm_vol(mask);
Vfa = spm_vol(dti_fa0);
Yfa = spm_read_vols(Vfa);

% Update FA and write out. We should ONLY update the translations, not the
% whole matrix. These are the three elements (1,4) (2,4) (3,4) of the
% V.mat. Lot of assumptions here, hope they always hold true!
Vfa.mat(1,4) = -Vmask.mat(1,4);
Vfa.mat(2,4) = Vmask.mat(2,4);
Vfa.mat(3,4) = Vmask.mat(3,4);
spm_write_vol(Vfa,Yfa);
