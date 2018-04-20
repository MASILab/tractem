% Process HCP zip file for DSI Studio tractography work


%% Setup

% Location of DSI Studio
dsi_studio = '/Applications/dsi_studio.app/Contents/MacOS/dsi_studio';

% SPM12
spm_dir = '/path/to/spm12';

% Script location
code_dir = '/path/to/masimatlab/trunk/users/rogersbp/dsi_scripts';

% Where to find image files. We are assuming the HCP preprocessed format,
% which has files with specific names in specific places. Unzip them first.
% Directories names are assumed to be six-digit numbers. Fully qualified
% path is required.
hcp_dir = '/path/to/HCP';

% Recon to use - HCP can use GQI
model = 'GQI';


%% Process

% Get our toolkits in the path
addpath(genpath(code_dir));
addpath(spm_dir);

% Atlas FA image for normalisation
atlas = [code_dir '/atlas/rJHU-ICBM-FA-2mm-TAL.nii'];

% Get a list of HCP format directories (directory name is 6-digit number)
dirs = dir(hcp_dir);
names = cellstr(char(dirs.name));
subjs = regexp(names,'^\d{6}$','match');
subjs = [subjs{~cellfun(@isempty,subjs)}];


%% Loop through directories
% Note that we change directory to the appropriate location ahead of each
% DSI Studio command - DSI Studio is a bit inconsistent about where it
% looks for files, and a lot of these files have the same name for every
% subject. DSI Studio will automatically find our bval, bvec, mask, and
% grad_dev images in the directory with the dwi images.

for s = 1:length(subjs)
	
	% Files for this subject
	[zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs] = get_HCP_filenames( ...
		[hcp_dir '/' subjs{s}]);
	
	% Run the processing
	process_subject( ...
		code_dir,dsi_studio,atlas,zt1,zseg,zdwi,zmask,zgrad,bvals,bvecs,model)

end

