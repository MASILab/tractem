function frec2rec(filename,quantizer)
if(~exist('quantizer'))
    quantizer=1;
end
parrec = loadPARfREC([filename]);
if(parrec.caps)

    fp = fopen([filename '.REC'],'wb','ieee-le');
else

    fp = fopen([filename '.rec'],'wb','ieee-le');
end
for j = 1:length(parrec.scans)
    for k = 1:size(parrec.scans{1},3)
        slice = parrec.scans{j}(:,:,k);
        fwrite(fp,uint16(round(double(slice(:))*quantizer)),'uint16');
    end
end
fclose(fp);

