function mn = computeMean(targetFile,varargin)
% mn = computeMean(targetFile,varargin)
%
% Compute the mean of a set of image volumes. The results are 
% written to the target file if it is not the empty string.
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

mn = zeros(size(pr{1}.scans{1}));
for j=1:length(pr)
    mn = pr{j}.scans{1}+mn;    
end
mn = mn./length(pr);

if(~isempty(targetFile))
    fp = fopen(targetFile,'wb','ieee-le');
    if(fp<0)
        error(['Cannot open file for writing: ' targetFile]);
    end
    fwrite(fp,mn(:),'float');
    fclose(fp);
end