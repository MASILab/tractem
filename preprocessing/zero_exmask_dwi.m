function zero_exmask_dwi(dwi,mask)

Vdwi = spm_vol(dwi);
Ydwi = spm_read_vols(Vdwi);

Vmask = spm_vol(mask);
Ymask = spm_read_vols(Vmask);

for v = 1:length(Vdwi)
	q = Ydwi(:,:,:,v);
	q(Ymask(:)==0) = 0;
	spm_write_vol(Vdwi(v),q);
end

