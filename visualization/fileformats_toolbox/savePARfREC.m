function savePARfREC(parrec, filename)

quantizer = 0;
if(parrec.caps)
    savePAR(parrec,[filename '.PARv2'],quantizer);
    fp = fopen([filename '.fREC'],'wb','ieee-le');
else
    savePAR(parrec,[filename '.parv2'],quantizer);
    fp = fopen([filename '.frec'],'wb','ieee-le');
end 


for j = 1:length(parrec.scans)
    for k = 1:size(parrec.scans{1},3)
        slice = parrec.scans{j}(:,:,k);
        fwrite(fp,single(slice(:)),'float32');
    end
end
fclose(fp);
