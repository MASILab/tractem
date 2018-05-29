clc
clear all
close all

addpath('/Users/greerjm1/Documents/MATLAB/NIfTI_20140122/')
addpath('/Users/greerjm1/Documents/MATLAB/along-tract-stats')
addpath('/Users/greerjm1/Documents/workingcode/imoverlay/')

% D = '/Users/greerjm1/Dropbox (VUMC)/whole_brain_regions_set2_165436/density/';
D = '/Volumes/Data/Dropbox (VUMC)/tractography/complete_HCP_subjects/135124_Yufei/postproc/';
files = dir(D);
filenames = cellstr(char(files.name));
dropfiles = false(length(files),1);
dropfiles(ismember(filenames,{'.','..','.DS_Store','README.rtf', 'README.txt', 'QA', 'tracking_parameters.ini', 'density'})) = true;
dropfiles(~cellfun(@isempty,strfind(filenames,'tal_fib.gz'))) = true;
files = files(~dropfiles);

% background = '/Volumes/Data/WM_Subjects/165436/T1w/Diffusion/wwCOM_dwi.nii.gz';
% system(['gunzip "' background '"']);
% basevol = load_nii(background(1:end-3));
% basevol = basevol.img(:,:,:,1); % use just first volume
% system(['gzip "' background(1:end-3) '"']);

background = '/Volumes/Data/Dropbox (VUMC)/tractography/complete_HCP_subjects/135124_Yufei/135124_gqi_fib_qa.nii.gz';
% background = [D '5708_tal_fib_qa.nii.gz'];
basevol = load_nii(background);
basevol = basevol.img(:,:,:,1); % use just first volume

if any(strcmp({files.name}, 'QA'))==0
    mkdir( [D '/' 'QA'])
end

%%
for j=1:length(files)
    
    if ~files(j).isdir, continue, end
    
    alldens = dir([D  files(j).name filesep '*_density.nii.gz']);
    alltrk = dir([D  files(j).name filesep '*_tract.trk.gz']);
    
    for d = 1:length(alldens)
        
        density =  [D  files(j).name '/' alldens(d).name];
        system(['gunzip "' density '"']);
        vol = load_nii(density(1:end-3));
        system(['gzip "' density(1:end-3) '"']);
        
        trk_file = [density(1:end-14) 'tract.trk.gz'];
        [~,trkn] = fileparts(trk_file);
        trkn = strrep(trkn,'_tract.trk','');
        trk_name = [files(j).name ' ' trkn];
        
        figure
        p = get(gcf,'Position');
        p(3:4) = [700 700];
        set(gcf,'Position',p);
        subplot(2,2,1)
        overlay = squeeze(sum(vol.img,3));
        baseimg = squeeze(basevol(:,:,floor(end/2)));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(rgb)
        title(trk_name, 'Interpreter', 'none')
        
        
        subplot(2,2,2)
        overlay = squeeze(sum(vol.img,2));
        baseimg = squeeze(basevol(:,floor(end/2),:));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(imrotate(rgb, 90))
        
        
        subplot(2,2,3)
        overlay = squeeze(sum(vol.img,1));
        baseimg = squeeze(basevol(floor(end/2),:,:));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(imrotate(rgb, 90))
        
        drawnow
        %pause(.01);
        
        subplot(2,2,4)
        system(['cat "' trk_file '" | gzip -d > foo.trk'])
        [header, tracks] = trk_read('foo.trk');
        system('rm foo.trk')
        
        if(isstruct(header))
            
            hold on;
            tracks_subset = tracks(randperm(length(tracks)));
            tracks_subset = tracks_subset(1:5000);
            tic
            trk_plot(header,tracks_subset)
            toc
            title(trk_name, 'Interpreter', 'none');
            view(60,-30)
        end
        
        print(gcf, '-bestfit','-dpdf',  [D 'QA' filesep alldens(d).name(1:end-15)])
        
        drawnow
        
        
    end
    
end


