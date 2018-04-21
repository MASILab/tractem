movies = dir('movie*.mat');
movies = movies(randperm(length(movies)));
curMovie=loadMovie(movies(1).name,[1175 1675 3]);

movie = {}; 
MOD = 270; 
stride = 30; 
jFrame=0;
for j=1:(length(movies)-1)
    disp(j)
    nextMovie = loadMovie(movies(j+1).name,[1175 1675 3]);
    movie(jFrame+(1:stride))=curMovie(1+mod(jFrame+(1:stride)-1,MOD));
    jFrame = jFrame+stride;
    lin = linspace(0,1,stride);
    for jT=1:length(lin)
        fr=curMovie{mod(jFrame+jT-1,MOD)+1}*(1-lin(jT))+...
            nextMovie{mod(jFrame+jT-1,MOD)+1}*(lin(jT));
        movie(jFrame+jT)={fr};
    end
    jFrame = jFrame+stride;    
    curMovie = nextMovie;    
end

v = VideoWriter('newfile2.avi','Motion JPEG AVI');
v.Quality = 95;
open(v);
for i=1:length(movie)
  writeVideo(v,movie{i});
end
close(v);
