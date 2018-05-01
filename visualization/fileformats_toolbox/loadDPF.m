function gradients = loadDPF(filename)
% function gradients = loadDPF(filename)
%
% Load gradient directions from a DPF file. 
%
% (C)opyright 2005, Bennett Landman, bennett@bme.jhu.edu
% Revision History:
% Created: 2/11/2005

fp = fopen(filename, 'rt');
txt = char(fread(fp))';
fclose(fp);

txt = txt(regexp(txt,'Begin_Of_Gradient_Table:'):regexp(txt,'End_Of_Gradient_Table:'));
n  = regexp(txt,'(?<idx>[\.\-\d]+):\s*(?<x>[\.\-\d]+),\s*(?<y>[\.\-\d]+),\s*(?<z>[\.\-\d]+)','names');
for j=1:length(n)
    gradients(1+str2num(n(j).idx)) = struct('x',str2num(n(j).x),'y',str2num(n(j).y),'z',str2num(n(j).z));
end
