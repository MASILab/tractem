function savePARRECavw(parrec, idx,filename,orient)
% Updated Apr 27 2006 - now handles Coronal images
if(~exist('orient','var'))
    a  = [parrec.hdr.img(:).orient];
    orient = unique({a(:).orient});
    if(length(orient)>1)
        error('savePARRECavw: Multiple slice orientations not supported within a single file');
    end
    orient=orient{1};
end
avw = parrec.avw;
%  Analyze: 
% 	orient: 
% 			0 - transverse unflipped
% 			1 - coronal unflipped
% 			2 - sagittal unflipped
% 			3 - transverse flipped
% 			4 - coronal flipped
% 			5 - sagittal flipped
a=avw;
switch upper(orient)
    case 'TRA'
        % Axial
        avw.hdr.hist.orient = 0;
        avw.img = parrec.scans{idx}(:,end:-1:1,:);% AVW is R->L,P->A, REC is R->L,A->P
    case 'SAG'
        % Sag
        avw.hdr.hist.orient = 0;
        avw.img = permute(parrec.scans{idx}(end:-1:1,end:-1:1,end:-1:1),[3 1 2]);% AVW is R->L,P->A, REC is R->L,A->P        
%         warning('savePARRECavw: Orient SAG not tested. may want to forceAxial option -jfarrell - blandman.')
        avw.hdr.dime.dim(2:4) = a.hdr.dime.dim(1+[3 1 2]);
        avw.hdr.dime.pixdim(2:4) = avw.hdr.dime.pixdim(1+[3 1 2]);
%         avw.hdr.pixdim(2:4) = permute(a.hdr.pixdim,[3 1 2]);
    case 'COR'
        % Coronal
        avw.hdr.hist.orient = 0;
        avw.img = parrec.scans{idx}(:,end:-1:1,:);% AVW is R->L,P->A, REC is R->L,A->P
	warning('savePARRECavw: Orient COR not tested. may want forceAxial option -jfarrell - blandman.')   
    otherwise
        error('savePARRECavw: Unknown orientation.')
end
% Remove Nan and Inf values
% avw.hdr.dime.datatype = 16
avw.img(find(~isfinite(parrec.avw.img(:))))=0;
avw_img_write(avw,filename);
