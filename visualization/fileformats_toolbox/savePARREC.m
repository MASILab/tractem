function savePARREC(parrec, filename, quantizer,nov2)
if(~exist('nov2'))
    nov2=0;
end
if(nov2)
    ext ='';
else
    ext='v2';
end
if(~exist('quantizer','var'))
    try
    quantizer = parrec.hdr.img(1).vis.scale_slope;
    catch
    quantizer =[];
    end
    if(isempty(quantizer))
        quantizer =0.01;
        warning('savePARREC: No quanitizer defined: Using 0.01.')
    end
end
parrec.hdr.scn.pix_bits = 16;
if(parrec.caps)
    savePAR(parrec,[filename '.PAR' ext],quantizer);
    fp = fopen([filename '.REC'],'wb','ieee-le'); % DTI proc requires little endian
else
    savePAR(parrec,[filename '.par' ext],quantizer);
    fp = fopen([filename '.rec'],'wb','ieee-le');
end
for j = 1:length(parrec.scans)
    for k = 1:size(parrec.scans{1},3)
        slice = parrec.scans{j}(:,:,k);
        fwrite(fp,uint16(min(2^16-1,round(double(slice(:))*quantizer))),'uint16');
    end
end
fclose(fp);
