function saveTDF(rows,file)
% function rows = saveTDF(file)
% Save a Tab Delimited Text file with a header row. 
% Write field names of the rows stucture into the first row.
% Each entry in rows is then saved by value. 
%
% Bennett Landman, NRI, 9/12/03


fp = fopen(file,'wt');


tab = char(9);

fields = fieldnames(rows);

for j=1:length(fields)
    fprintf(fp, ['%s' tab], fields{j});
end
fprintf(fp,'\n');
for j=1:length(rows)
    for k=1:length(fields)
        entry = rows(j).(fields{k});
        if(isnumeric(entry))
            fprintf(fp,['%12.8f' tab],entry);
        else 
            fprintf(fp,['%s' tab], entry);
        end
    end
        fprintf(fp,'\n');    
end
    
    fclose(fp);
