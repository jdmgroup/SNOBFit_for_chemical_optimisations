function checkName(SNOB)

	% only check if the name is valid when the experiment is started, as could cause
	% conflict with other parameters

	if ~SNOB.continuing
		% check if working file already exists
		working_exists = exist([SNOB.filepath,'/Working/',SNOB.name,'.mat']);

		% check if Results folder already exists
		results_exists = isdir([SNOB.filepath,'/Results/',SNOB.name]);

		if (working_exists | results_exists)
			if working_exists	
				% check if any files with appended numbers exist already
				numbered_exists = exist([SNOB.filepath,'/Working/',SNOB.name,'(1).mat']);

				% get a list of all numbered files if they exist
				if numbered_exists
					working_extant = dir([SNOB.filepath,'/Working/',SNOB.name,'(*).mat']);
					[~,order] = sort([working_extant(:).datenum]);
					working_names = {working_extant(order).name};
					last_file = working_names{end};
					number_start = regexp(last_file,'\([0-9]+\)') + 1;
					last_number = str2num(last_file(number_start:end-5));
					next_number = last_number + 1;
					valid_name = [SNOB.name,'(',num2str(next_number),')'];
				else
					valid_name = [SNOB.name,'(1)'];
				end
			end
		else
			valid_name = SNOB.name;
		end


		if ~strcmp(valid_name,SNOB.name)
			SNOB.name = valid_name;
			fprintf('Name changed to %s, to prevent naming conflict!\n',valid_name)
		end
	end

end

