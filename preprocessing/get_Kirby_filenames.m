function [t1,seg,dwi,mask,grad,bvals,bvecs] = get_Kirby_filenames(kirby_dir)

% Given a directory where a Kirby preprocessed DWI image set was downloaded
% from XNAT, get the filenames of the relevant files for diffusion
% processing.

% Get session name
q = strsplit(kirby_dir,'/');
subj = q{end-1};
sess = q{end};

% Other directory names
dtiqa = ['Kirby21-x-' subj '-x-' sess '-x-DTI-x-dtiQA_v2'];
mprage = 'MPRAGE-x-MPRAGE-x-MPRAGE';
tgz = ['dtiQA_Kirby21-x-' subj '-x-' sess '.tgz'];
tgz_dir = [kirby_dir '/' sess '/' dtiqa '/TGZ'];
fulltgz = [tgz_dir '/' tgz];

% Extract DWI and scheme file from tgz
system(['cd ' tgz_dir ' && tar -zxf ' fulltgz ' extra/RegIm.nii']);
system(['cd ' tgz_dir ' && tar -zxf ' fulltgz ' extra/scheme.txt']);
dwi = [tgz_dir '/extra/RegIm.nii'];

% Convert scheme file to bval/bvec
S = importdata([tgz_dir '/extra/scheme.txt'],' ',1);
bvec = S.data(:,1:3)';
bval = S.data(:,4)';
bvals = [tgz_dir '/extra/bval.txt'];
bvecs = [tgz_dir '/extra/bvec.txt'];

fid = fopen(bvals,'wt');
fprintf(fid,'%0.2f ',bval);
fprintf(fid,'\n');
fclose(fid);

fid = fopen(bvecs,'wt');
fprintf(fid,'%0.6f ',bvec(1,:));
fprintf(fid,'\n');
fprintf(fid,'%0.6f ',bvec(2,:));
fprintf(fid,'\n');
fprintf(fid,'%0.6f ',bvec(3,:));
fprintf(fid,'\n');
fclose(fid);


% Mask file
system(['cd ' tgz_dir ' && tar -zxf ' fulltgz ' QA_maps/Mask2_mask.nii']);
mask = [tgz_dir '/QA_maps/Mask2_mask.nii'];

% Zero out ex-mask voxels in the DWI so DSI Studio doesn't get confused
zero_exmask_dwi(dwi,mask);


% Filenames for T1 and segmented T1
zt1 = [kirby_dir '/' sess '/' mprage '/NIFTI/' sess '_MPRAGE.nii.gz'];
system(['gunzip ' zt1]);
t1 = zt1(1:end-3);

zseg = [kirby_dir '/' sess '/SEG/' sess '_MPRAGE_seg.nii.gz'];
system(['gunzip ' zseg]);
seg = zseg(1:end-3);

% Register T1 and seg to dwi B=0. First compute b=0, then COM shift, then
% SPM coreg estimate. No need to resample at this stage but we will copy
% the files to avoid changing original images.
[t1,seg] = coregister_t1(dwi,bvals,t1,seg);


grad = []; % No grad dev for BLSA

