clc
clear all
close all

% Adjust these variables with each subject
subjectID = '165436'; 
rater = 'Roza'; 
project = 'HCP';

% Add the NIfTI_20140122 and MATLAB/along-tract-stats packagaes
addpath('/Users/greerjm1/Documents/MATLAB/NIfTI_20140122/')
addpath('/Users/greerjm1/Documents/MATLAB/along-tract-stats')

% The location of the subject data
D = ['/Volumes/Data/Dropbox (VUMC)/tractography/complete_' project '_subjects'];
D = [D filesep subjectID '_' rater '/']; 

% Isolate just the tract directories
files = dir(D);
filenames = cellstr(char(files.name));
dropfiles = false(length(files),1);
dropfiles(ismember(filenames,{'.','..','.DS_Store','README.rtf', 'README.txt', 'QA', 'tracking_parameters.ini', 'density'})) = true;
dropfiles(~cellfun(@isempty,strfind(filenames,'tal_fib.gz'))) = true;
files = files(~dropfiles);

% The HCP and BLSA subjects were processed differently and have a different
% qa volume name
if project == 'HCP'
    background = [D subjectID '_gqi_fib_qa.nii.gz'];
elseif project == 'BLSA'
    background = [D ubjectID '_tal_fib_qa.nii.gz'];
else
    fprint('Error')
end

% Load the FA image. This will be the background image for the density maps
basevol = load_nii(background);
basevol = basevol.img(:,:,:,1); % use just first volume

% Put all of the PDF results into a directory called QA. If QA does not
% already exist, create the directory
if any(strcmp({files.name}, 'QA'))==0
    mkdir( [D '/' 'QA'])
end

%%

% This for loop reviews each tract directory
for j=1:length(files)
    
    % Confirm that the file list are directories
    if ~files(j).isdir, continue, end
    
    % Identify density files
    alldens = dir([D  files(j).name filesep '*_density.nii.gz']);
    % Identify tract files
    alltrk = dir([D  files(j).name filesep '*_tract.trk.gz']);
    
    % This for loop review each density file: left and right
    for d = 1:length(alldens)
        
        % Define density file. Unzip it. Load density files. Then zip it back up 
        density =  [D  files(j).name '/' alldens(d).name];
        system(['gunzip "' density '"']);
        vol = load_nii(density(1:end-3));
        system(['gzip "' density(1:end-3) '"']);
        
        % Define tract file. Unzip it. Load tract files. Then zip it back up 
        trk_file = [density(1:end-14) 'tract.trk.gz'];
        [~,trkn] = fileparts(trk_file);
        trkn = strrep(trkn,'_tract.trk','');
        trk_name = [files(j).name ' ' trkn];
        
        figure
        p = get(gcf,'Position');
        p(3:4) = [700 700];
        set(gcf,'Position',p);
        
        % Overlap the background FA image and the density map on an axial plane
        subplot(2,2,1)
        overlay = squeeze(sum(vol.img,3));
        baseimg = squeeze(basevol(:,:,floor(end/2)));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(rgb)
        title(trk_name, 'Interpreter', 'none')
        
        % Overlap the background FA image and the density map on a coronal plane
        subplot(2,2,2)
        overlay = squeeze(sum(vol.img,2));
        baseimg = squeeze(basevol(:,floor(end/2),:));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(imrotate(rgb, 90))
        
        % Overlap the background FA image and the density map on a saggital plane
        subplot(2,2,3)
        overlay = squeeze(sum(vol.img,1));
        baseimg = squeeze(basevol(floor(end/2),:,:));
        
        rgb = (repmat(baseimg,[1 1 3])-min(baseimg(:)))/(max(baseimg(:))-min(baseimg(:)));
        baseimg = baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:));
        rgb(:,:,1) = min(1,baseimg/(max(baseimg(:))-min(baseimg(:)))+overlay/max(overlay(:)));
        imagesc(imrotate(rgb, 90))
        
        drawnow
        %pause(.01);
        
        % Show the tract file in 3D
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


