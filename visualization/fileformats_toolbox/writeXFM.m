function writeXFM(Q,filename)
fp = fopen(filename,'wt');
for j=1:4
    fprintf(fp,'%.12f %.12f %.12f %.12f\n',Q(j,1),Q(j,2),Q(j,3),Q(j,4));
end
fclose(fp);