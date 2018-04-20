function imfile = ziptest(imfile)

if isempty(imfile), return, end

if strcmp(imfile(end-3:end),'.nii')
	system(['gzip ' imfile]);
	imfile = [imfile '.gz'];
end
