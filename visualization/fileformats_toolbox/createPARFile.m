function createPARFile(newPARfilename,ds,FOV,dims,orient,apFhRl,patPos,prepDIR,bval,par_version)
%
% Generate a bare bones PAR file for compatibility. Parameters:
% 
% newPARfilename - (string) filename of file to generate (will be overwritten)
% ds - (1x4) dimension of the 4D volume in voxels
% FOV - (1x3) field of view of each volume in mm (ordering may be different from dims based on orientation)
% dims - (1x3) dimensions of voxels in mm 
% orient - (string: TRA, COR, SAG) orientation of scanning volume
% apFhRl - (1x3) slice angulation in degrees
% patPos - (string) e.g., Head First Supine
% prepDIR - (string) e.g., Anterior-Posterior
% bval - (1xdim(4)) the b-value for each volume in the file
% par_version - (string: V3, V4) Version of PAR file to create OPTIONAL (default = 'V4') 
%
% Author Information:
% Bennett Landman, bennett@bme.jhu.edu
%
% Revision History: 
% 5/25/2006 Initial parVer. 

% 5/25/2006 Jonathan Farrell.  used ds in place of dim, used apFhRl in place of apRLFH, used prepDIR as input in plae of PatORI
% replaced release with par_version, as release is Philips software release (like Rel10.4)

% 5/30/2006 Jonathan Farrell  write angulation values to synthetic par file, write slice thickness to
% synthetic par file.  Make idx number increment by 1 with each line in par file

% 9/21/2007 Bennett Landman, changed pixel spacing parameter in image slice

if(sum(ds<=0)+(length(ds)~=4))
    error('Incorrect format: dims: [Nx Ny Nz Nvol], all greater than 0');
end

if(length(FOV)~=3)
    error('Incorrect format: FOV: [FOV_lr FOV_ap FOV_si]');
end

if(length(dims)~=3)
    error('Incorrect format: dims: [RESx RESy SLICE_THICKNESS]');
end  

if(~exist(par_version))
	par_version = 'V4';
end  

% Warn if orient is not consistent with voxel sizes
switch upper(orient)
    case 'TRA'
        % Axial
        slice_orientation=1;
        fov=max(FOV([1 3]));
        if((dims(1)~=dims(2))+(dims(1)~=fov/ds(1)))
            warning('In plane dimension do not equal FOV(1)/dim(1)');
        end
        if(dims(3)~=FOV(2)/ds(3))
            warning('Slice thickness does not equal FOV(2)/dim(3)');
        end
    case 'SAG'
        % Sag
        slice_orientation=2;
        fov=max(FOV([1 2]));
        if((dims(1)~=dims(2))+(dims(1)~=fov/ds(1)))
            warning('In plane dimension do not equal FOV(1)/dim(1)');
        end
        if(dims(3)~=FOV(3)/ds(3))
            warning('Slice thickness does not equal FOV(3)/dim(3)');
        end
    case 'COR'
        % Coronal
        slice_orientation=3;
        fov=max(FOV([2 3]));
        if((dims(1)~=dims(2))+(dims(1)~=fov/ds(1)))
            warning('In plane dimension do not equal FOV(2)/dim(1)');
        end
        if(dims(3)~=FOV(1)/ds(3))
            warning('Slice thickness does not equal FOV(1)/dim(3)');
        end
    otherwise
        error('Incorrect format: Unknown orientation.')
end

if(length(apFhRl)~=3)
    error('Incorrect format: 3 angles required for apFhRl');
end

if(length(bval)~=ds(4))
    error('Incorrect format: one b-value must be given for each volume');
end

if(~exist('par_version','var'))
    par_version = 'V4';
end


ver=0;
switch(par_version)
    case 'V3'
        ver =3;
        try
        basePAR = loadPAR([fileparts(mfilename('fullpath')) filesep 'default_v3.par']);
        catch
            error('Missing file: default_v3.par.');
        end
    case 'V4'
        ver=4;
        try
            basePAR = loadPAR([fileparts(mfilename('fullpath')) filesep 'default_v4.par']);
        catch 
            error('Missing file: default_v4.par.');
        end
        basePAR.orient.patient_pos = patPos;
        basePAR.orient.prep_dir = prepDIR;
    otherwise
        error(['par_version not supported: ' par_version]);
end


% First, fix the basic header information:
basePAR.scn.recon_res = ds(1:2);
basePAR.scn.fov = FOV;
basePAR.slicethk = dims(3);
basePAR.slicegap = 0;
basePAR.max.num_slices = ds(3);
basePAR.max.num_dynamics = ds(4)*ds(3); 
basePAR.orient.ang_midslice = apFhRl;

img = basePAR.img(1);
img.info.recon_res = ds(1:2);
img.special.pix_spacing = fov./ds(1:2);
basePAR.img = img;


joncount = 0;
for jVol=1:ds(4)
    for jSlice=1:ds(3)
        jDynamic = ds(3)*(jVol-1)+jSlice;
        
        img.info.dynamic_scan_num = jVol;
	
	% =======
	% added by JonFarrell
	img.info.idx_rec = joncount;
	joncount = joncount+1;
	img.info.slicethk = dims(3);
	% ========
	
        img.special.diffusion_b_factor = bval(jVol);
        img.orient.img_angulation = apFhRl;
        img.orient.slice_orientation = slice_orientation;
        img.orient.orient = orient;
        img.info.slice_num = jSlice;
        img.orient.img_offcentre = [0 0 0];
        % Also update?
        % img.special.echo_time
        % img.special.image_flip_angle
        
        basePAR.img(jDynamic) = img;         
    end
end

savePAR(basePAR, newPARfilename,1);
