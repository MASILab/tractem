function dti_fa0 = restore_nii_geom(mask,dti_fa0)

% Restore correct geometry to FA image after DSI studio mangles it.
Vmask = spm_vol(mask);
Vfa = spm_vol(dti_fa0);
Yfa = spm_read_vols(Vfa);

Vout = rmfield(Vfa,{'private','mat'});
Vout.mat = Vmask.mat;
Yout = Yfa(end:-1:1,:,:);
spm_write_vol(Vout,Yout);
