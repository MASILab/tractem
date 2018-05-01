function parrec = loadPARfREC(varargin)
% function parrec = loadPARREC(parfilename, recfilename, selectedScans)
%
% Using the PAR header file defined by parfilename and REC data format file
% in recfilename, load the header data and image data. If selectedScans is
% specified (optional), then only the image files with the specifed index
% will be loaded.
%
% (C)opyright 2005, Bennett Landman, bennett@bme.jhu.edu
% Revision History:
% Created: 2/11/2005
% 3/26/05 Forced correction for floating point images
% 10/23/2006 Simplified error handling

if(nargin==3)
    parfilename=varargin{1};
    recfilename=varargin{2};
    selectedScans=varargin{3};
end
if(nargin==2)
    if(isnumeric(varargin{2}))
        parfilename=[varargin{1} '.par'];
        if(exist(parfilename,'file') || exist([parfilename 'v2'],'file'))

            recfilename=[varargin{1} '.frec'];
            selectedScans=varargin{2};
            parrec = loadPARfREC(parfilename,recfilename,selectedScans);
            parrec.caps = 0;
            return;
        else
            parfilename=[varargin{1} '.PAR'];
            recfilename=[varargin{1} '.fREC'];
            selectedScans=varargin{2};
            parrec = loadPARfREC(parfilename,recfilename,selectedScans);
            parrec.caps = 1;
            return;
        end
    else
        parfilename=varargin{1};
        recfilename=varargin{2};
        selectedScans = [];
    end
end
if(nargin==1)
    parfilename=[varargin{1} '.par'];
    if(exist(parfilename,'file') || exist([parfilename 'v2'],'file'))
        %parfilename=[varargin{1} '.par'];
        recfilename=[varargin{1} '.frec'];
        selectedScans = [];
        parrec = loadPARfREC(parfilename,recfilename,selectedScans);
        parrec.caps = 0;
        return;
    else
        parfilename=[varargin{1} '.PAR'];
        recfilename=[varargin{1} '.fREC'];
        selectedScans = [];
        parrec = loadPARfREC(parfilename,recfilename,selectedScans);
        parrec.caps = 1;
        return;
    end
end
parrec.hdr = loadPAR(parfilename);
parrec.hdr.scn.pix_bits = 32;
[parrec.scans,parrec.scanIdxDat] = loadREC(recfilename, parrec.hdr,selectedScans,1);
parrec.hdr.NumberOfVolumes = length(parrec.scanIdxDat);
q = [parrec.hdr.img(:).info]; q= [q.dynamic_scan_num];
parrec.hdr.img = parrec.hdr.img(find(ismember(q,[parrec.scanIdxDat.dynamic_scan_num])));


% parrec.avw = create_avw(size(parrec.scans{1}), [parrec.hdr.scn.fov(1)/parrec.hdr.scn.recon_res(1) ...
%         parrec.hdr.scn.fov(3)/parrec.hdr.scn.recon_res(2) parrec.hdr.scn.slicethk]);
px = size(parrec.scans{1});
if(length(px)<3) % Support for single slice files
    px(3) = 1;
end 
switch(parrec.hdr.img(1).orient.orient)
    case 'TRA'
        order=[1 3 2];
    case 'COR'
        order = [2 3 1];
    case 'SAG'
        order = [1 2 3];
end
dims=parrec.hdr.scn.fov(order)./px;
parrec.avw = create_avw(px, dims);

parrec.avw.hdr.dime.datatype =16; % Floating Point