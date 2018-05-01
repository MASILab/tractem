function MTR = computeMTR(targetFile,varargin)
% MTR = computeMTR(targetFile,varargin)
%
% Compute magnetic transfer images from KKI center MTR volumes.
% Average numerator and denominator before computing ratio.
% The targetFile is the destination for a headerless float file.
% Any number (1+) of MTR (KKI scan format) may be included in the
% variable number of arguments. The results are written to the
% target file if it is not the empty string.
%
% Bennett Landman, bennett@bme.jhu.edu
%
% Created: 6/6/06
for j=1:length(varargin)
    try
        pr{j} = loadPARREC(varargin{j});
    catch
        try
            pr{j} = loadPARfREC(varargin{j});
        catch
            try
                pr{j} = avw_img_read(varargin{j});
            catch
                error(['Cannot load image as PAR/REC, PAR/fREC, or ANALYZE: ' varargin{j}]);
            end
        end
    end
end

M0 = zeros(size(pr{1}.scans{1}));
Mw=M0;
for j=1:length(pr)
    M0 = pr{j}.scans{1}+M0;
    Mw = pr{j}.scans{2}+Mw;
end
MTR = 1-Mw./M0;

if(~isempty(targetFile))
    fp = fopen(targetFile,'wb','ieee-le');
    if(fp<0)
        error(['Cannot open file for writing: ' targetFile]);
    end
    fwrite(fp,MTR(:),'float');
    fclose(fp);
end