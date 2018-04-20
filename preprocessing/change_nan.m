function fname = change_nan(fname)
% Function to change nan to zero
V = spm_vol(fname);
n = numel(V);
for k = 1:n
	Y = spm_read_vols(V(k));
	Y(~isfinite(Y(:))) = 0;
	spm_write_vol(V(k),Y);
end
