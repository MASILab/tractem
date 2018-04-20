function make_Tal(dsi_studio,wcdwi,wcgrad,wcmask,wb_table,tal_dir,model)

% Create a subdirectory and move in the needed files using DSI Studio
% hardcoded filenames.
mkdir(tal_dir);
movefile(wcdwi,[tal_dir '/data.nii']);
ziptest([tal_dir '/data.nii']);
if ~isempty(wcgrad)
	movefile(wcgrad,[tal_dir '/grad_dev.nii']);
	ziptest([tal_dir '/grad_dev.nii']);
end
movefile(wcmask,[tal_dir '/nodif_brain_mask.nii']);
ziptest([tal_dir '/nodif_brain_mask.nii']);
movefile(wb_table,[tal_dir '/b_table.txt']);

% Create src file
disp('Creating Tal src file')
system([ ...
	'cd ' tal_dir ' ; ' ...
	dsi_studio ' --action=src ' ...
	'--source=data.nii.gz ' ...
	'--b_table=b_table.txt ' ...
	'--output=tal_src.gz ' ...
	'> tal_src.log'
	]);

% Diffusion reconstruction for tractography
switch model
	case 'GQI'
		
		disp('Tal GQI reconstruction')
		system([ ...
			'cd ' tal_dir ' ; ' ...
			dsi_studio ' --action=rec ' ...
			'--source=tal_src.gz ' ...
			'--method=4 ' ...
			'--param0=1.25 ' ...
			'> tal_rec.log ; ' ...
			'mv tal_src.gz.*.fib.gz tal_fib.gz' ...
			]);
		
	case 'DTI'
		disp('Tal DTI reconstruction')
		system([ ...
			'cd ' tal_dir ' ; ' ...
			dsi_studio ' --action=rec ' ...
			'--source=tal_src.gz ' ...
			'--method=1 ' ...
			'> tal_rec.log ; ' ...
			'mv tal_src.gz.*.fib.gz tal_fib.gz' ...
			]);
		
	case 'QBI4'
		disp('Tal QBI reconstruction')
		system([ ...
			'cd ' tal_dir ' ; ' ...
			dsi_studio ' --action=rec ' ...
			'--source=tal_src.gz ' ...
			'--method=3 ' ...
			'--param0=0.006 ' ...
			'--param1=4 ' ...
			'> tal_rec.log ; ' ...
			'mv tal_src.gz.*.fib.gz tal_fib.gz' ...
			]);
		
	otherwise
		error('Unknown diffusion model')
		
end
