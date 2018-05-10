function absT1 = computeAbsoluteT1(targetFile,flipAngleLow,flipAngleHigh,TR,varargin)
% absT1 = computeAbsoluteT1(targetFile,flipAngleLow,flipAngleHigh,TR,varargin))
%
% Compute absolute T1 images from pairs of low and high spin echo images. 
% targetFile - destination file for a float output (not written if [])
% flipAngleLow - the low flip angle (default 15 deg if <=0)
% flipAnglehigh - the high flip angle (default 60 deg if <=0)
% TR - repetition time (default 100 ms if <=0)
% varargin - must be an even length sequence (>=2) of images that
% correspond to pairs of (low,high) flip angle images. Do not include file extension. 
%
% Bennett Landman, bennett@bme.jhu.edu
%
% Created: 6/6/06
if(mod(length(varargin),2))
    error('Image volumes must be specified in pairs.');
end
    
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
for j=1:2:length(pr)
    S1 = pr{j}.scans{1}+S1;
    S2 = pr{j+1}.scans{1}+S2;
end

R = S2./S1;

if(flipAngleLow<=0)
    flipAngleLow = 15;
end

if(flipAngleHigh<=0)
    flipAngleHigh = 60;
end

if(TR<=0)
    TR = 100;
end
flipAngleLow=flipAngleLow*pi/180;
flipAngleHigh=flipAngleHigh*pi/180;
absT1 = -TR./real(log((sin(flipAngleHigh)-R*sin(flipAngleLow))./(cos(flipAngleLow)*sin(flipAngleHigh)-R*cos(flipAngleHigh)*sin(flipAngleLow))));

if(~isempty(targetFile))
    fp = fopen(targetFile,'wb','ieee-le');
    if(fp<0)
        error(['Cannot open file for writing: ' targetFile]);
    end
    fwrite(fp,absT1(:),'float');
    fclose(fp);
end