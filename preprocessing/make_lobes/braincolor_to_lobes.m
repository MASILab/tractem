function braincolor_to_lobes(seg_file,out_dir,code_dir)

%% Make lobe ROIs from the braincolor segmentation

% Mostly use the '47' set from hierarchical parcellation:
%
% Frontal:
%    5, 6
%   33,34
%   35,36
%   43,44
%
% Parietal:
%   37,38
%
% Occipital:
%   39,40
%   45,46
%
% Temporal:
%  41,42

% Then we need to change membership of a couple of regions using the
% original full (133) segmentation:
%     Hippocampus in the full seg is 31,32, 47,48. Move this to temporal
%     lobe. And in insula, 102/103 and 112/113 should be assigned to
%     frontal, not temporal. Cuneus 166/167 168/169 should be moved from
%     frontal to parietal.

labels = readtable([code_dir '/make_lobes/braincolor_hierarchy_STAPLE.txt'], ...
	'ReadVariableNames',true);

% For each label in the full set (133), assign it to one of our 8 lobes
% depending on the 47 values.
lobenames = table(categorical({ ...
	'R_Frontal', ...
	'L_Frontal', ...
	'R_Parietal', ...
	'L_Parietal', ...
	'R_Occipital', ...
	'L_Occipital', ...
	'R_Temporal', ...
	'L_Temporal' ...
	})','VariableNames',{'Lobe'});
lobenames.Label = (1:height(lobenames))';
writetable(lobenames,fullfile(out_dir,'lobes_labels.csv'));
labels.lobes = zeros(size(labels.x133));
for k = 1:height(labels)
	switch labels.x47(k)
		case {5,33,35,43}
			labels.lobes(k) = find(lobenames.Lobe=='R_Frontal');
		case {6,34,36,44}
			labels.lobes(k) = find(lobenames.Lobe=='L_Frontal');
		case {37}
			labels.lobes(k) = find(lobenames.Lobe=='R_Parietal');
		case {38}
			labels.lobes(k) = find(lobenames.Lobe=='L_Parietal');
		case {39,45}
			labels.lobes(k) = find(lobenames.Lobe=='R_Occipital');
		case {40,46}
			labels.lobes(k) = find(lobenames.Lobe=='L_Occipital');
		case {41}
			labels.lobes(k) = find(lobenames.Lobe=='R_Temporal');
		case {42}
			labels.lobes(k) = find(lobenames.Lobe=='L_Temporal');
			
	end
end

% Fix the hippocampus
labels.lobes(ismember(labels.x133,[31 47])) = ...
	find(lobenames.Lobe=='R_Temporal');
labels.lobes(ismember(labels.x133,[32 48])) = ...
	find(lobenames.Lobe=='L_Temporal');

% Fix the insula
labels.lobes(ismember(labels.x133,[102 112])) = ...
	find(lobenames.Lobe=='R_Frontal');
labels.lobes(ismember(labels.x133,[103 113])) = ...
	find(lobenames.Lobe=='L_Frontal');

% Fix the cuneus
labels.lobes(ismember(labels.x133,[166 168])) = ...
	find(lobenames.Lobe=='R_Parietal');
labels.lobes(ismember(labels.x133,[167 169])) = ...
	find(lobenames.Lobe=='L_Parietal');


% Save the label list
writetable(labels(:,{'x133','lobes'}), ...
	fullfile(out_dir,'braincolor_lobe_mapping.csv'))

% Make the single lobe image
V = spm_vol(seg_file);
Yseg = spm_read_vols(V);
Ylobes = zeros(size(Yseg));
for k = 1:height(lobenames)
	Ylobes(ismember(Yseg(:),labels.x133(labels.lobes==k))) = k;
end
Vout = V;
Vout.fname = fullfile(out_dir,'lobes_all.nii');
spm_write_vol(Vout,Ylobes);

% One image per lobe
for k = 1:height(lobenames)
	Yout = zeros(size(Yseg));
	Yout(Ylobes(:)==k) = 1;
	Vout = V;
	Vout.fname = fullfile(out_dir,['lobe_' char(lobenames.Lobe(k)) '.nii']);
	spm_write_vol(Vout,Yout);
end
