function Q = writePrinceRaw(vol,filename)

%Q = fminsearch(inline('sum((dat(:)-Quant*min(255,max(0,round(dat(:)/Quant)))).^2)','Quant','dat'),1,[],double(vol))
% 
% Q = fminsearch(inline('sum((dat(:)-Quant*min(255,max(0,round(dat(:)/Quant)))))',...
%     'Quant','dat'),255/double(max(vol(:))),[],double(vol(:,:,(round([-15 0 15]+end/2)))));
[N,C] = hist(vol(:),1024);
Q = fminsearch(inline('sum(max(255,(N.*(C-Quant*min(255,max(0,round(C/Quant))))).^2))',...
    'Quant','N','C'),255/double(max(vol(:))),[],N,C);

vol = min(255,max(0,round(double(vol)/Q)));

fp=fopen(filename,'wb','ieee-le');
fwrite(fp,vol(:),'uint8');
fclose(fp);