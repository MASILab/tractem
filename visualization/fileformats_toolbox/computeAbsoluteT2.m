function absT2 = computeAbsoluteT2(targetFile,deltaTE,varargin)
% absT2 = computeAbsoluteT2(targetFile,deltaTE,varargin)
%
% Compute absolute T2 images from dual echo spin echo images.
% targetFile - destination file for a float output (not written if [])
% deltaTE - the difference in TE between the 1st and 2nd echos (defaults to
% 80-28.2 if <=0)
% varargin - any number of DE TSE images with the same sets of TE's, do not include file extension.
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

S1 = zeros(size(pr{1}.scans{1}));
S2=S1;
for j=1:length(pr)
    S1 = pr{j}.scans{1}+S1;
    S2 = pr{j}.scans{2}+S2;
end

if(deltaTE<=0)
    deltaTE = 80-28.2;
end
absT2 = -deltaTE./real(log(abs(S2./S1)));

if(~isempty(targetFile))
    fp = fopen(targetFile,'wb','ieee-le');
    if(fp<0)
        error(['Cannot open file for writing: ' targetFile]);
    end
    fwrite(fp,absT2(:),'float');
    fclose(fp);
end