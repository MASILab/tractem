function [recdat, pardat] = loadREC(filename, par, selectedScans,applyRescale)
% function [recdat, pardat] = loadREC(filename, par, selectedScans)
%
% Given the header data in par, load image data from filename (a REC file).
% If selectedScanes is not [], then only those scans specified will be
% loaded.
%
% (C)opyright 2005, Bennett Landman, bennett@bme.jhu.edu
% Revision History:
% Created: 2/11/2005
% Bug Fix: 5/04/2005 - Corrected function of "selectScans" parameter

if(~exist(filename,'file'))
    error(['loadREC: Unable to find file: ' filename]);
end

switch(par.scn.pix_bits)
    case 32
        type = 'float32';
    case 16
        type = 'uint16'; % fixed?
    case 8
        type='uint8';
    otherwise
        error('Unsupported data type');
end

mx_slice = [];
scans = [];
for j=1:length(par.img)
    scans = unique([scans par.img(j).info.dynamic_scan_num]);
end
if(~exist('selectedScans'))
    selectedScans = 1:length(scans);
end
if(isempty(selectedScans))
    selectedScans = 1:length(scans);
end
if(max(selectedScans)>length(scans))
    warning(['Only ' num2str(length(scans)) ' scans found. Ignoring out of bounds request.']);
end

slices = zeros(size(scans));
for j=1:length(par.img)
    idx=find(par.img(j).info.dynamic_scan_num==scans);
    slices(idx) = max([slices(idx) par.img(j).info.slice_num]);
end
for j=1:length(scans)
    if(sum(selectedScans==j))
        if(applyRescale)
            recdat{find(j==selectedScans)} = (zeros([par.scn.recon_res(1) par.scn.recon_res(2) slices(j)],'single'));
        else
            switch(par.scn.pix_bits)
                case 32
                    recdat{find(j==selectedScans)} = single(zeros([par.scn.recon_res(1) par.scn.recon_res(2) slices(j)],'single'));
                case 16
                    recdat{find(j==selectedScans)} = (zeros([par.scn.recon_res(1) par.scn.recon_res(2) slices(j)],'uint16'));
                case 8
                    recdat{find(j==selectedScans)} = (zeros([par.scn.recon_res(1) par.scn.recon_res(2) slices(j)],'uint8'));
            end
        end

        pardat(find(j==selectedScans)).dynamic_scan_num = scans(j);
    end
end

fp = fopen(filename,'rb','ieee-le');
if(fp==-1)
    error(['Unable to open: ' filename]);
end
img_len = prod(par.scn.recon_res);
for j=1:length(par.img)
    idx=find(par.img(j).info.dynamic_scan_num==scans);
    if(sum(selectedScans==idx))

        if(strcmp(type,'float32'))
            recdat{find(idx==selectedScans)}(:,:,par.img(j).info.slice_num)= reshape(fread(fp,img_len,type,'ieee-le'),par.scn.recon_res(:)');
        else
            if(isfield(par.img(j),'vis'))
                if(isfield(par.img(j).vis,'rescale_slope') && isfield(par.img(j).vis,'rescale_intercept'))
                    %ok
                else
                    applyRescale=0;
                end
            else
                applyRescale=0;
            end
            if(applyRescale) %rescale?

                %             # === PIXEL VALUES =============================================================
                %             #  PV = pixel value in REC file, FP = floating point value, DV = displayed value on console
                %             #  RS = rescale slope,           RI = rescale intercept,    SS = scale slope
                %             #  DV = PV * RS + RI             FP = DV / (RS * SS)
                % FP = (PV*RS+RI)/(RS*SS)
                recdat{find(idx==selectedScans)}(:,:,par.img(j).info.slice_num)= ...
                    (reshape(fread(fp,img_len,type,'ieee-le'),par.scn.recon_res(:)')*par.img(j).vis.rescale_slope+...
                    par.img(j).vis.rescale_intercept)...
                    /(par.img(j).vis.scale_slope*par.img(j).vis.rescale_slope);
            else
                recdat{find(idx==selectedScans)}(:,:,par.img(j).info.slice_num)= reshape(fread(fp,img_len,type,'ieee-le'),par.scn.recon_res(:)');
            end
        end
    else
        % Skip this slice, we don't want it.
        fseek(fp,par.scn.pix_bits/8*img_len,0);
    end
end
fclose(fp);

