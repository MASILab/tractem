% Code to render tract densities as maximum intensity projections (MIP)
% on the realigned T1w images. 
% 
% Instructions: 
% Download the sample (or other) aligned volume to the "structure" path.
% Download the density images to "density" folder. 
% Edit the "clr" variable to change the color of the overlay. [R G B] in 0
% to 1. 
% Edit the tracts variable to name the densities to add to the overlay. 
% Run this script. 
%
% May 1, 2018 Bennett Landman
addpath(genpath(pwd))
structure = load_nii('./structure/wcT1w_acpc_dc_restore_1.25.nii')

%Set the color here: 
clr = [1 0 0];

% setup which tracts here
tracts = {'bcc_density','gcc_density','scc_density'};

for jT = 1:length(tracts)
    nii = load_nii(['./density/' tracts{jT} '.nii']);
    if(jT==1)
        density = nii;
    else
        density.img = density.img+nii.img;
    end
end

figure(1)
sl = structure.img(:,:,floor(end/2));
d = double(max(density.img,[],3)); d= d/max(d(:));
CLR = repmat(reshape(clr,[1 1 3]),[size(sl,1) size(sl,2) 1]);

overlay = (repmat(sl,[1 1 3])-min(sl(:)))/(max(sl(:))-min(sl(:)));
imagesc(CLR.*repmat(d,[1 1 3])+overlay.*(1-repmat(d,[1 1 3])))
axis equal off


figure(2)
sl = squeeze(structure.img(:,floor(end/2),:));
d = squeeze(double(max(density.img,[],2))); d= d/max(d(:));
CLR = repmat(reshape(clr,[1 1 3]),[size(sl,1) size(sl,2) 1]);

overlay = (repmat(sl,[1 1 3])-min(sl(:)))/(max(sl(:))-min(sl(:)));
imagesc(flipdim(permute(CLR.*repmat(d,[1 1 3])+overlay.*(1-repmat(d,[1 1 3])),[2 1 3]),1))

axis equal off 


figure(3)
sl = squeeze(structure.img(floor(end/2),:,:));
d = squeeze(double(max(density.img,[],1))); d= d/max(d(:));
CLR = repmat(reshape(clr,[1 1 3]),[size(sl,1) size(sl,2) 1]);

overlay = (repmat(sl,[1 1 3])-min(sl(:)))/(max(sl(:))-min(sl(:)));
imagesc(flipdim(permute(CLR.*repmat(d,[1 1 3])+overlay.*(1-repmat(d,[1 1 3])),[2 1 3]),1))

axis equal off 
