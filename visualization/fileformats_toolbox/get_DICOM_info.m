function [ds,FOV,dims,apFhRl,orient,prepDIR,patPos,bval,release,date] = get_DICOM_info()

% AUTHOR:  		Jonathan Farrell
% NAME:			get_DICOM_info.m
% CREATION DATE:	MAY 24, 2006

% ==================
% PURPOSE
% ==================

% Get specific information from the dicom header so that a synthetic PAR file can be generated.  The information that
% is extracted is the minimal necessary to do gradient table creation, dtiproc and CATNAP.

% ====================
% INSTRUCTIONS
% ======================

% FILE CAN BE ANY DWI DICOM HEADER (ie.. NOT THE b = 0).  Recomend selecting the LAST DICOM header in series
file = '/g2/jfarrell/data/DTI/MR/1.3.46.670589.11.0.0.11.4.2.0.5406.5.5604.2006051712010967879';

% ============================
% get the date of the scan
% ============================
ss = ['dcm_dump_file ' file ' | grep 0008 | grep 0020 '];
[s,w] = unix(ss);
tt = w(strfind(w,'Study Date//')+12:end);
date = [num2str(tt(1:4)) '.' num2str(tt(5:6)) '.' num2str(tt(7:8))];

% ================================
% get data matrix information
% ======================================
ss = ['dcm_dump_file ' file ' | grep 0028 | grep 0010 '];
[s,w] = unix(ss);
tt = str2num(w(strfind(w,'Rows//')+6:end));
nrows = tt(2);

ss = ['dcm_dump_file ' file ' | grep 0028 | grep 0011 '];
[s,w] = unix(ss);
tt = str2num(w(strfind(w,'Columns//')+9:end));
ncols = tt(2);

ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1074 '];
[s,w] = unix(ss);
FOVx = str2num(w(strfind(w,'FOV X//')+7:end));
ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1075 '];
[s,w] = unix(ss);
FOVy = str2num(w(strfind(w,'FOV Y//')+7:end));
ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1076 '];
[s,w] = unix(ss);
FOVz = str2num(w(strfind(w,'FOV Z//')+7:end));

ss = ['dcm_dump_file ' file ' | grep 0028 | grep 0030 '];
[s,w] = unix(ss);
tt = w(strfind(w,'Pixel Spacing//')+15:end);
x_spacing = str2num(tt(1:strfind(tt,'\')-1));
y_spacing = str2num(tt(strfind(tt,'\')+1:end));

ss = ['dcm_dump_file ' file ' | grep 2005 | grep 107e '];
[s,w] = unix(ss);
slice_thickness = str2num(w(strfind(w,'Slice Thickness//')+17:end));

% =========================
% get n volumes and n slices information 
% =========================
ss = ['dcm_dump_file ' file ' | grep 2001 | grep 102d '];
[s,w] = unix(ss);
tt = str2num(w(strfind(w,'Stack//')+7:end));
nvolumes = tt(1);
nslices = tt(2);

% =================================
% Get Slice Angulation Information
% ==================================
ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1071 '];
[s,w] = unix(ss);
ap = str2num(w(strfind(w,'X//')+3:end));
ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1072 '];
[s,w] = unix(ss);
fh = str2num(w(strfind(w,'Y//')+3:end));
ss = ['dcm_dump_file ' file ' | grep 2005 | grep 1073 '];
[s,w] = unix(ss);
rl = str2num(w(strfind(w,'Z//')+3:end));

% ========================================================
% get patient_orientation and patient position information
% ========================================================
ss = ['dcm_dump_file ' file ' | grep 0018 | grep 5100 '];
[s,w] = unix(ss);
tt = w(strfind(w,'Patient Position//')+18:end);
if strcmpi(tt(1:2),'HF')
	patient_position = 'hf';
	
else
	error('not sure how to deal with patient_orientation')
end

if strcmpi(tt(3),'S')
	patient_orientation = 'sp';
else
	error('not sure how to deal with patient_orientation')
end

if (strcmpi(tt(1:2),'HF') & strcmpi(tt(3),'S'))
	patPos = 'Head First Supine';
end


% =====================================
% get slice orientation information
% =====================================
ss = ['dcm_dump_file ' file ' | grep 2001 | grep 100b '];
[s,w] = unix(ss);
tt = w(strfind(w,'100b//')+6:end);
if strfind(tt,'TRANSVERSAL')
	orient = 'TRA';
	
else
	error('not sure how to deal with slice orientation')
end

% ===========================
% get foldover and fat shift
% ===========================
ss = ['dcm_dump_file ' file ' | grep 0018 | grep 1312 '];
[s,w] = unix(ss);
tt = w(strfind(w,'Phase Encoding Direction//')+26:end);

ss = ['dcm_dump_file ' file ' | grep 2005 | grep 107b '];
[s,ttt] = unix(ss);

if (strfind(tt,'COL') & strfind(ttt,'AP'))
	foldover = 'AP';
	prepDIR  = 'Anterior-Posterior';
elseif strfind(tt,'ROW')
	foldover = 'RL';
	prepDIR = 'Right-Left';		
else
	error('not sure how to deal with foldover')
end
% ==================
% get release
% ====================
ss = ['dcm_dump_file ' file ' | grep 0018 | grep 1020 '];
[s,w] = unix(ss);
tt = w(strfind(w,'Software Version//')+18:end);
ttt = tt(1:strfind(tt,'\')-1);
if strfind(ttt,'10.4')
	release = 'Rel10.4';
elseif strfind(ttt,'11.1')
	release =  'Rel11.1';
elseif strfind(ttt,'11.2')
	release =  'Rel11.2'
elseif (strfind(ttt,'1.2') & ~strfind(ttt,'11'))
	release =  'Rel1.2';
elseif strfind(ttt,'1.5')
	release =  'Rel1.5';
end


% =====================
% get the b value
% =====================
ss = ['dcm_dump_file ' file ' | grep 2001 | grep 1003 '];
[s,w] = unix(ss);
b_value = str2num(w(strfind(w,'B-Factor//')+10:end));


% =====================================================================
% OUTPUT FORMATING TO MESH WITH createPARfile.m by Bennett Landman
% =====================================================================
ds = [nrows,ncols,nslices,nvolumes];
FOV = [FOVx,FOVy,FOVz];
dims = [x_spacing,y_spacing,slice_thickness];
apFhRl = [ap,fh,rl];
bval = ones(1,ds(4))*b_value;
bval(1) = 0;


