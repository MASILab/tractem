function outpar=writeAVWtoPARfREC(analyzeFileTag,parrecFile,parrecHDR)
[f,filetag] = strtok(parrecHDR,'.');
L = min(length(filetag),3);
caps = min(filetag(1:L)==upper(filetag(1:L)));
nFiles=dir([analyzeFileTag '_Vol_*.img']);
par = loadPAR(parrecHDR);
a  = [par.img(:).orient];
orient = unique({a(:).orient});
if(length(orient)>1)
    error('savePARRECavw: Multiple slice orientations not supported within a single file');
end
orient=orient{1};
if(~caps)
    copyPAR(par,[parrecFile '.parv2'],length(nFiles));
    outpar=[parrecFile '.parv2'];
else
    copyPAR(par,[parrecFile '.PARv2'],length(nFiles));
    outpar = [parrecFile '.PARv2'];
end



if(~caps)
    fp =fopen([parrecFile '.frec'],'wb','ieee-le');
else
    fp =fopen([parrecFile '.fREC'],'wb','ieee-le');
end
for j=1:length(nFiles)
    avw = avw_img_read([analyzeFileTag '_Vol_' sprintf('%03d',j)]);
        switch upper(orient)
        case 'TRA'
            % Axial
            avw.img =avw.img(:,end:-1:1,:);% AVW is R->L,P->A, REC is R->L,A->P
        case 'SAG'
            % Sag
            %parrec.avw.img = parrec.scans{idx}(:,end:-1:1,:);
                        avw.img =avw.img(:,end:-1:1,:);% AVW is R->L,P->A, REC is R->L,A->P
%            order = [2 3 1];
%            avw.img=avw.img(end:-1:1,:,end:-1:1);
%            avw.img=permute(avw.img(:,:,:),order);   
%            warning('writeAVWtoPARREC: Orient SAG not supported yet. Contact bennett@bme.jhu.edu with example data and we will correct this problem.')
            warning('writeAVWtoPARREC: Partial Orient SAG not supported yet.')
        case 'COR'
            % Coronal                        
%            order = [1 3 2];
%            avw.img=avw.img(:,end:-1:1,end:-1:1);
%            avw.img=permute(avw.img(:,:,:),order);        
            avw.img =avw.img(:,end:-1:1,:);% AVW is R->L,P->A, REC is R->L,A->P            
                        warning('writeAVWtoPARREC: Partial Orient COR not supported yet.')
        otherwise
            disp('Unknown method.')
    end
    for k=1:size(avw.img,3)
        slice = avw.img(:,:,k); % NO SCALING BY DEFAULT!
        fwrite(fp,slice(:),'float');
    end
end
fclose(fp);


function copyPAR(par,target,nVols)
%par = loadPAR(parfile);
par.NumberOfVolumes = nVols;
q = [par.img.info];
oldVols = unique([q(:).dynamic_scan_num]);

if(nVols<length(oldVols))
    newimg = par.img(1);
    for j=1:length(par.img)
        if(sum(par.img(j).info.dynamic_scan_num==oldVols(1:nVols)))
            newimg(end+1)=par.img(j);
        end
    end
    par.img= newimg(2:end);
end
parrec.hdr = par;
savePAR(parrec,target,1);
