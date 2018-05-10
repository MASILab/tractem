%vol = load_nii_gz('Superior_occipital_WM_tract_density.nii.gz')

D = './tracts/'

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
set(gcf,'color','w')
% 
% 2.05	0.0422	scr*
% 2.26	0.0255	pcr*

trk = [dir([D filesep   'fxst*trk.gz'])];
map = jet(100);
clr = [map(end,:);map(end,:)];
for jT =1:length(trk)
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


    
