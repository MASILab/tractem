function N= writePARfRECtoAVW(parfrecFile,analyzeFileTag)
% adjusts file order
parrec = loadPARfREC(parfrecFile);
N=length(parrec.scans);

% Check to make sure we are only in one orientation (performance
% enhancement here)
a  = [parrec.hdr.img(:).orient];
orient = unique({a(:).orient});
if(length(orient)>1)
    error('writePARfRECtoAVW: Multiple slice orientations not supported within a single file');
end
orient=orient{1};
for j=1:N
    savePARRECavw(parrec, j,[analyzeFileTag '_Vol_' sprintf('%03d',j)],orient)

end