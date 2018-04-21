function FR = loadMovie(filename,sz2)
M = load(filename,'M');
if(~exist('sz2'))

for i=1:length(M.M)
    sz(:,i) = size(M.M(i).cdata);
end
sz2= max(sz');
end

for i=1:length(M.M)
    FR{i} = ones(sz2,'uint8')*255;
    offset=floor((sz2-size(M.M(i).cdata))/2);
    FR{i}(offset(1)+(1:size(M.M(i).cdata,1)),...
        offset(2)+(1:size(M.M(i).cdata,2)),:)=M.M(i).cdata;
end