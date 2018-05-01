function rows = loadTDF(file)
% function rows = loadTDF(file)
% Load a Tab Delimited Text file with a header row. 
% Reads the first row as column names and all other rows
% as data entries. Returns a structure with on entry for each row. 
% Column headers are returned as variables in the structure. 
% Numeric columns are detected and converted. String columns are 
% unmodified. (Note '.' is interpreted as the empty number.) 
%
% Bennett Landman, NRI, 9/5/03

fp = fopen(file,'rt');
header = fgets(fp);
fclose(fp);

col={};
j=1;
[col{j}, header] = strtok(header);
while(~isempty(header))
    j=j+1;
    [c, header] = strtok(header);
    if(~isempty(c))
        col{j}=c;
    end
end


tag = '';
out = [];
for j=1:length(col)
    tag = ['%s' tag];
    if(length(out)>0)
        out = [out ', ' col{j}];
    else 
        out = col{j};
    end
end

eval(['[' out ']' '= textread(file,tag,''headerlines'',1,''delimiter'',char(9));']);
for j=1:length(col)
    for k=1:eval(['length(' col{j} ');'])
        rows(k).(col{j})= eval([col{j} '{' num2str(k) '}']);
    end
end

for j=1:length(col)
    todig = 1;
    for k=1:length(rows)
        txt = rows(k).(col{j}); 
        try
            if(~isnumber(txt))
                todig=0;
                break;
            end
        catch 
            todig =0;
            break;
        end
    end
    if(todig)
        for k=1:length(rows)
            rows(k).(col{j}) = str2num(rows(k).(col{j})); 
        end
    end
end

function bool = isnumber(txt)
if(strcmp(txt,'.'))
    bool=1;
else
n = str2num(txt);
dp = find(txt=='.');
if(~isempty(dp))
    bool = strcmp(sprintf(['%0.' num2str(length(txt)-dp) 'f'],n),txt);
else
    bool = strcmp(num2str(n),txt);
end
end