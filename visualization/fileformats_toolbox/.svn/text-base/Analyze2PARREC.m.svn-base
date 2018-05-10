function Analyze2PARREC(filename,bvalues,flipY)
[pth,file,ext] = fileparts(filename);
if(isempty(pth))
    pth = pwd;
end
avw = avw_img_read4D(filename,0); % force axial orient (no flipping)

%function createPARFile(newPARfilename,ds,FOV,dims,orient,apFhRl,patPos,prepDIR,bval,par_version)
FOV = double(avw.hdr.dime.dim(2:4)).*double(avw.hdr.dime.pixdim(2:4));
createPARFile([pth filesep file '.PAR'],...
    double(avw.hdr.dime.dim(2:5)),... % need to update avw_img_read for 4D volumes
    FOV([1 3 2]),...
    double(avw.hdr.dime.pixdim(2:4)), ...
    'TRA',...
    [0 0 0],...
    'Head First Supine',...
    'Anterior-Posterior',...
    bvalues,...
    'V4');

dat = avw.img(:);
if(exist('flipY','var'))
    if(flipY)
        dat = avw.img(:,end:-1:1,:,:); % Should FLIP to be True Analyze Compatible (but no one is...)
    end
end
dat = floor(dat/max(dat(:))*(2^15-1)); % Truncate to 15 bits
fp = fopen([pth filesep file '.REC'],'wb','ieee-le');
fwrite(fp,dat(:),'uint16');
fclose(fp);

%
% Generate a bare bones PAR file for compatibility. Parameters:
%
% newPARfilename - (string) filename of file to generate (will be overwritten)
% ds - (1x4) dimension of the 4D volume in voxels
% FOV - (1x3) field of view of each volume in mm (ordering may be different from dims based on orientation)
% dims - (1x3) dimensions of voxels in mm
% orient - (string: TRA, COR, SAG) orientation of scanning volume
% apFhRl - (1x3) slice angulation in degrees
% patPos - (string) e.g., Head First Supine
% prepDIR - (string) e.g., Anterior-Posterior
% bval - (1xdim(4)) the b-value for each volume in the file
% par_version - (string: V3, V4) Version of PAR file to create OPTIONAL (default = 'V4')
%