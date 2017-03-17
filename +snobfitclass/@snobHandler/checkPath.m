function checkPath(SNOB,src,event)

	filepath = SNOB.filepath;

	path_extant = dir(filepath);
	if isempty(path_extant)
		mkdir(filepath);
	end

	working_extant = dir([filepath,'/Working']);
	if isempty(working_extant)
		mkdir([filepath,'/Working']);
	end

	results_extant = dir([filepath,'/Results']);
	if isempty(results_extant)
		mkdir([filepath,'/Results']);
	end

end