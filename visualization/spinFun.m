% Make nice spinning movies for example 
% TractEM tracts. 
% Bennett Landman, April 19, 2018
addpath(genpath(pwd))

GRP = {[1],[2 3],[4 5],[6],[7 8],[9 10],[11 12],[13 14],[15 16],[17 18],...
    [19 20],[21],[22 23],[24 25],[26 27],[28],[29],[30 31],...
    [32 33],[34 35],[36],[37 38],[39],[40 41],[42 43],[44 45],...
    [46],[47],[48 49],[50 51],[52 53],[54 55],[56],[57 58],[59 60]}

colormap = jet(length(GRP));
% used to check:
% for i=1:length(GRP), disp('     '); for j=1:length(GRP{i}), disp(trk(GRP{i}(j)).name), end, end
D = './tracts/'
for jGRP=1:length(GRP)
    files = dir(['./movie/movie' num2str(jGRP) '.mat']);
    if(length(files)>0)
        disp('already done with movie');
        disp(jGRP)
        continue;
    end
    figure(1)
    clf
    trk = dir([D filesep   '*trk.gz']);
    clr = jet(length(trk));
    for jT =1:length(trk)
        if((jT==26)+(jT==28)+(jT==30)+(jT==32))
            continue;
        end
        disp([jGRP jT])
        trkfile = [D  filesep trk(jT).name]
        system(['cat ' trkfile ' | gzip -d > foo.trk']);
        
        [header, tracks] = trk_read('foo.trk');
        system('rm foo.trk');
        
        %trk_plotbl(clr(jT,:),100,header, tracks)
        
        M = {};
        for j=1:2000:length(tracks)
            M{j} = tracks(j).matrix(1:8:end,:);
        end
        
        h=streamtube(M,1); set(h,'facealpha',.01,'edgecolor','none');
        for j = 1:length(h)
            d = h(j).CData;
            d(:,:,1) = .1;
            d(:,:,2) = .1;
            d(:,:,3) = .1;
            set(h(j),'CData',d,'CDataMapping','direct','facealpha',.01);
        end
        
        axis equal off
        hold on
        
    end
    
    
    for jT =GRP{jGRP}
        disp(jGRP)
        trkfile = [D  filesep trk(jT).name]
        system(['cat ' trkfile ' | gzip -d > foo.trk']);
        
        [header, tracks] = trk_read('foo.trk');
        system('rm foo.trk');
        
        %trk_plotbl(clr(jT,:),100,header, tracks)
        
        M = {};
        for j=1:100:length(tracks)
            M{j} = tracks(j).matrix(1:4:end,:);
        end
        
        h=streamtube(M,1); set(h,'facealpha',1,'edgecolor','none');
        for j = 1:length(h)
            d = h(j).CData;
            d(:,:,1) = colormap(jGRP,1);
            d(:,:,2) =colormap(jGRP,2);
            d(:,:,3) =colormap(jGRP,3);
            set(h(j),'CData',d,'CDataMapping','direct','facealpha',1);
        end
        
        axis equal off
        hold on
        
    end
    set(gcf,'color','w')
    axis tight
    light
    A1 = [linspace(0,180,90) linspace(180,90,45) linspace(90,90,45) linspace(90,90,45) linspace(90,0,45)];
    A2 = [linspace(0,0,90) linspace(0,0,45) linspace(0,90,45) linspace(90,0,45) linspace(0,0,45) ];
    set(gcf,'color',[1 1 1])
    set(gcf,'position',[0 0 1080 720])
    axis equal off tight
    clear M
    for i=1:length(A1)
        disp([jGRP i length(A1)])
        view(A1(i),A2(i));
        drawnow;
        M(i)=getframe;
    end
    save(['./movie/movie' num2str(jGRP)],'M')
end


