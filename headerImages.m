
D = './tracts/'

for jF=1:20
    figure(1)
    clf
    trk = dir([D filesep   '*trk.gz']);
    clr = jet(length(trk));
    for jT =1:length(trk)
        if((jT==26)+(jT==28)+(jT==30)+(jT==32))
            continue;
        end
        disp(jT)
        trkfile = [D  filesep trk(jT).name]
        system(['cat ' trkfile ' | gzip -d > foo.trk'])
        
        [header, tracks] = trk_read('foo.trk');
        system('rm foo.trk')
        
        %trk_plotbl(clr(jT,:),100,header, tracks)
        
        M = {};
        for j=1:500:length(tracks)
            M{j} = tracks(j).matrix(1:8:end,:);
        end
        
        h=streamtube(M,1); set(h,'facealpha',.01,'edgecolor','none')
        for j = 1:length(h)
            d = h(j).CData;
            d(:,:,1) = .1;
            d(:,:,2) = .1;
            d(:,:,3) = .1;
            set(h(j),'CData',d,'CDataMapping','direct','facealpha',.01)
        end
        
        axis equal off
        hold on
        disp(jT)
        
    end
    
    
    
    q = (randperm(length(trk)));
    for jTT=1:5
        
        jT=q(jTT);
        disp(jT)
        trkfile = [D  filesep trk(jT).name]
        system(['cat ' trkfile ' | gzip -d > foo.trk'])
        
        [header, tracks] = trk_read('foo.trk');
        system('rm foo.trk')
        
        %trk_plotbl(clr(jT,:),100,header, tracks)
        
        M = {};
        for j=1:100:length(tracks)
            M{j} = tracks(j).matrix(1:4:end,:);
        end
        
        h=streamtube(M,1); set(h,'facealpha',1,'edgecolor','none')
        for j = 1:length(h)
            d = h(j).CData;
            d(:,:,1) = clr(jT,1);
            d(:,:,2) =clr(jT,2);
            d(:,:,3) =clr(jT,3);
            set(h(j),'CData',d,'CDataMapping','direct','facealpha',1)
        end
        
        axis equal off
        hold on
        disp(jT)
        
    end
    set(gcf,'color','w')
    axis tight
    
    
    light
    set(gcf,'color','w')
    set(gcf,'position',[0 0 1080 720])
    view(0,0);
    drawnow
    F((jF-1)*3+1)=getframe;
    view(90,0)
    drawnow
    F((jF-1)*3+2)=getframe;
    view(90,90)
    drawnow
    F((jF-1)*3+3)=getframe;
    
end

for i=1:48
    sz = size(F(i).cdata);
    q = imresize(F(i).cdata,sz(1:2).*940/sz(2));
    qq = q(floor(size(q,1)/2)+(-98:99),:,:);
    imwrite(qq,['./hdr/header-' num2str(i) '.png']);
end
    


