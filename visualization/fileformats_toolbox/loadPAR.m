function par = loadPAR(filename)
% function par = loadPAR(filename)
%
% Load a PAR header file (simplified Phillips format).
%
% Author:   Bennett Landman
% Created:  Jan 25 2005
% History:  Feb 01 2005 - Updated par heirarchy
%           Jun 16 2005 - Forced to retain file format
%           Jan 24 2006 - added version detection
%           Apr 27 2006 - bug fix TRA/SAG/COR
%           Dec 28 2006 - included Par 4.1 parameters
if(~exist(filename))
    filename = [filename 'v2'];
end
if(~exist(filename))
    error(['loadPAR: ' filename ' does not exist.']);
end

[par,vars,slicevars] = defaultPARVars;
fp = fopen(filename, 'rt');
imgTagFormat =[];
par.fmt = {}; % fileformat
par.scnfmt={}; % slice scan format
doneslices=0;
while(~feof(fp))
    line = strtrim(fgetl(fp)); % needed to support variable spaced 12/28/06
    if(length(line)<1)
        par.fmt{end+1} = {'comment',line};
        continue;
    end
    switch(line(1))
        case '#'        % comment
            par.fmt{end+1} = {'comment',line};
            if(strcmp('# === IMAGE INFORMATION DEFINITION =============================================',strtrim(line)))
                [imgTagFormat,par]= parseImgTagFormat(fp,slicevars,par);
            end
            blankImg = [];
            for j=1:length(imgTagFormat)
                blankImg.(imgTagFormat(j).mem).(imgTagFormat(j).var) = [];
            end

            continue;
        case '.'        % scan file variable
            [tag,key] = strtok(line,':');
            idx = strmatch(tag,vars(:,1));
            if(~isempty(idx))
                if(vars{idx,4})
                    par.(vars{idx,2}).(vars{idx,3}) = sscanf(strtrim(key(2:end)),'%f')';
                else
                    par.(vars{idx,2}).(vars{idx,3}) = strtrim(key(2:end));
                end
                par.fmt{end+1} = {'var',vars{idx,2},vars{idx,3}};
            else
                warning(['loadPAR: Unknown parameter declaration: ' line]);
                par.fmt{end+1} = {'comment',line};
            end
        otherwise       % parse as image slice information


            blankImg = [];
            par = parseScanImgLine(par,line,imgTagFormat,blankImg);
            blankImg=par.img(1);
            %if(~strcmp(par.fmt{end}{1},'SLICES'))
            if(~doneslices)
                doneslices=1;
                par.fmt{end+1}={'SLICES'};
            end

            %end
    end

end
fclose(fp);
q = [par.img.info];
par.NumberOfVolumes = length(unique([q(:).dynamic_scan_num]));
NoV = length(q)/length(unique([q(:).slice_num]));
if(NoV~=par.NumberOfVolumes)
    warning('loadPAR.m: Dynamic Scan Number does not match number of slices. Assuming slices are ordered.');


    cnt = zeros([1 max([q(:).slice_num])]);

    for j=1:length(par.img)
        cnt(par.img(j).info.slice_num) = cnt(par.img(j).info.slice_num)+1;
        par.img(j).info.dynamic_scan_num=cnt(par.img(j).info.slice_num);
    end
end
q = [par.img.info];
par.NumberOfVolumes = length(unique([q(:).dynamic_scan_num]));
switch(par.img(1).orient.orient)
    case 'TRA'
        if(par.scn.fov(1)~=par.scn.fov(3))
            warning('AXIAL (TRA): par.scn.fov(1)~=par.scn.fov(3). Setting to max');
            par.scn.fov = double(par.scn.fov);
            par.scn.fov([1 3])=max(par.scn.fov([1 3]));

        end
        if(par.scn.slicethk ~= (par.scn.fov(2)/par.max.num_slices))
            warning('Slice Thickness does not match fov/num_slices. ADJUSTING!!!');
            par.scn.slicethk = (par.scn.fov(2)/par.max.num_slices);
        end
    case 'COR'
        if(par.scn.fov(2)~=par.scn.fov(3))
            warning('CORONAL (COR): par.scn.fov(2)~=par.scn.fov(3). Setting to max');
            par.scn.fov = double(par.scn.fov);
            par.scn.fov([2 3])=max(par.scn.fov([2 3]));
        end
        if(par.scn.slicethk ~= (par.scn.fov(1)/par.max.num_slices))
            warning('Slice Thickness does not match fov/num_slices. ADJUSTING!!!');
            par.scn.slicethk = (par.scn.fov(1)/par.max.num_slices);
        end
    case 'SAG'
        if(par.scn.fov(2)~=par.scn.fov(1))
            warning('SAGITTAL (SAG): par.scn.fov(1)~=par.scn.fov(2). Setting to max');
            par.scn.fov = double(par.scn.fov);
            par.scn.fov([1 2])=max(par.scn.fov([1 2]));
        end
        if(par.scn.slicethk ~= (par.scn.fov(3)/par.max.num_slices))
            warning('Slice Thickness does not match fov/num_slices. ADJUSTING!!!');
            par.scn.slicethk = (par.scn.fov(3)/par.max.num_slices);
        end
end

if(par.scn.slicegap~=0)
    warning('Non-zero slice gap: adjusting slice thickness');
    % Read the header variables
    par.scn.slicethk = par.scn.slicethk+par.scn.slicegap;
    par.scn.slicegap=0;
end


% Determine File Volume/Slice Order (inputVolumeSliceOrder): 
% a) volume - all slices are listed (in order) for each volume before the next volume
% b) slices - the same slice is listed for all volumes before the next
% slice of the first volume (volumes are ordered)
% c) other - some other ordering (any ordering of volumes/slices is
% supported in the PAR file format)

% Procedure: Build a matrix with each row having: [VOLUME SLICE IDX]
SRC = zeros([length(par.img) 3]);
N=length(par.img);
for j=1:N
    SRT(j,1:3) = [par.img(j).info.dynamic_scan_num par.img(j).info.slice_num j];
end
SRT = sortrows(SRT);
if(sum(SRT(:,3)==(1:N)')==N)
    % This is in volume order
    par.inputVolumeSliceOrder = 'volume';    
else
    SRT = sortrows(SRT(:,[2 1 3]));
    if(sum(SRT(:,3)==(1:N)')==N)
    % This is in slice order
        par.inputVolumeSliceOrder = 'slice';        
    else
        par.inputVolumeSliceOrder = 'unknown';
        warning('loadPAR: Slice ordering is not a predefined type.');
        disp('This toolbox is compatalbe with arbitrary ordering of slices in PAR/REC files.');
        disp('However, other toolboxes or REC readers may assume a specific ordering.');
    end

    
end

% Read
% #
% # === PIXEL VALUES =============================================================
% #  PV = pixel value in REC file, FP = floating point value, DV = displayed value on console
% #  RS = rescale slope,           RI = rescale intercept,    SS = scale slope
% #  DV = PV * RS + RI             FP = DV / (RS * SS)
% #
function par = parseScanImgLine(par,line,imgTagFormat,blankImg)
h = sscanf(line, '%f');
if(length(h)~=sum([imgTagFormat(:).len]))
    error('loadPAR: Slice tag format does not match the number of enteries');
end
img = blankImg;
k=0;
for j=1:length(imgTagFormat)
    img.(imgTagFormat(j).mem).(imgTagFormat(j).var) = h(k+(1:imgTagFormat(j).len));
    k = k+imgTagFormat(j).len;
end
img.orient.orient = 'UNK';
if(img.orient.slice_orientation==1)       img.orient.orient = 'TRA';     end
if(img.orient.slice_orientation==2)       img.orient.orient = 'SAG';     end
if(img.orient.slice_orientation==3)       img.orient.orient = 'COR';     end
if(~isfield(par.scn,'pix_bits'))
    par.scn.pix_bits = img.info.pix_bits;
else
    if(isfield(img.info,'pix_bits'))
        if(par.scn.pix_bits ~= img.info.pix_bits)
            warning('loadPAR - REC file contains image slices with variable bits per pixel.');
        end
    end
end
if(~isfield(par.scn,'recon_res'))
    par.scn.recon_res = img.info.recon_res(:)';
else
    if(isfield(img.info,'recon_res'))
        if(par.scn.recon_res(:) ~= img.info.recon_res(:))
            warning('loadPAR - REC file contains image slices with variable reconstruction sizes.');
        end
    end
end

if(~isfield(par.scn,'slicethk'))
    par.scn.slicethk = img.info.slicethk;
else
    if(isfield(img.info,'slicethk'))
        if(par.scn.slicethk ~= img.info.slicethk)
            warning('loadPAR - REC file contains image slices with variable slice thickness.');
        end
    end
end


if(~isfield(par.scn,'slicegap'))
    par.scn.slicegap = img.info.slicegap;
else
    if(isfield(img.info,'slicegap'))
        if(par.scn.slicegap ~= img.info.slicegap)
            warning('loadPAR - REC file contains image slices with variable slice thickness.');
        end
    end
end

if(isempty(par.img))
    par.img = img;
else
    par.img(end+1) = img;
end

Vs = strfind( par.fmt{8}{2},'V');
try
    par.version = str2num(par.fmt{8}{2}((Vs+1):end));
catch
    par.version = -1;
end

function [fmt,par] = parseImgTagFormat(fp,vars,par)
fmt = [];
%fgetl(fp); % eat the comment line
line = strtrim(fgetl(fp));
par.fmt{end+1} = {'comment',line};
ok_comment = '#  The rest of this file contains ONE line per image, this line contains the following information:';
while(~strcmp(line,'# === IMAGE INFORMATION =========================================================='))
    if(length(line)>1)
        idx = strmatch(line,vars(:,1));
        if(isempty(idx))
            if(~strcmp(line,ok_comment))
                warning(['loadPAR: Cannot interpret slice variable: ' line]);
            end
        else
            fmt(end+1).len = vars{idx,2};
            fmt(end).mem=vars{idx,3};
            fmt(end).var=vars{idx,4};
            par.scnfmt{end+1} = {line,vars{idx,3},vars{idx,4}};
        end
    end
    line = strtrim(fgetl(fp));
    par.fmt{end+1} = {'comment',line};
end
