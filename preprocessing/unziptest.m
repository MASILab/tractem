function imfile = unziptest(imfile)

if isempty(imfile), return, end

if strcmp(imfile(end-2:end),'.gz')
	system(['gunzip ' imfile]);
	imfile = imfile(1:end-3);
end

