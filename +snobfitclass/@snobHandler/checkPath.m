function checkPath(SNOB) % JHB

	filepath = SNOB.filepath;

	path_extant = dir(filepath);
	if isempty(path_extant)
		mkdir(filepath);
	end

	
	if ~exist(fullfile(filepath,'Working'),'dir') % JHB
		mkdir(fullfile(filepath,'Working'));
	end

	if ~exist(fullfile(filepath,'Results'),'dir') % JHB
		mkdir(fullfile(filepath,'Results'));
	end

end