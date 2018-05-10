function str = safeTex(str)
% function str = safeTex(str)
% Convert tex special characters in str to \<character> so 
% that the string may be safely used in the matlab figure interface.
%
% Bennett Landman, 4/16/03
c = ['\_^'];
for j=1:length(c)
    s = [strfind(str,c(j))];
    for k=1:length(s);
        str = [str(1:(s(k)-1)) '\' str((s(k):length(str)))];
        s = s+1;
    end
end

