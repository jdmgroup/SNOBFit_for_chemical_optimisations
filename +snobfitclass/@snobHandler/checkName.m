function checkName(SNOB)

	% only check if the name is valid when the experiment is started, as could cause
	% conflict with other parameters
    
    valid_name = ''; % JHB - STOPS INITIAL ERROR

	if ~SNOB.continuing
		% check if working file already exists
		working_exists = exist(fullfile(SNOB.filepath,'Working',[SNOB.name,'.mat']),'file'); % JHB

		% check if Results folder already exists
		results_exists = isdir(fullfile(SNOB.filepath,'Results',SNOB.name)); % JHB

		if (working_exists || results_exists) % JHB EDIT ON | to ||
			if working_exists
                
				% check if any files with appended numbers exist already -
				% JHB - this test didn't work if you repeat optimisation
                wfs = dir(fullfile(SNOB.filepath, 'Working'));
                
                n_valid = 0;
                for i = 1:length(wfs)
                    if ~ismember(wfs(i).name,{'.','..','.DS_Store'}) % this deals with Mac layout files (which updates frequently and may be the last file)
                        n_valid = n_valid + 1;
                        valid_wfs(n_valid) = wfs(i);
                    end
                end
                
                base_exists = false;
                numbered_exists = false;
                
                base_name = SNOB.name(1:min(regexp(SNOB.name,'('))-1);
                
                for i = 1:length(valid_wfs)
                    if regexp(valid_wfs(i).name,base_name)
                        base_exists = true;
                        if ~isempty(regexp(valid_wfs(i).name,'(\d)','Once'))
                            numbered_exists = true;
                        end
                    end
                end
                
				%JHB - numbered_exists = exist(fullfile(SNOB.filepath,'Working',SNOB.name,'(1).mat')); % JHB

				% get a list of all numbered files if they exist
				if numbered_exists && n_valid && base_exists % JHB
					% JHB - working_extant = dir(fullfile(SNOB.filepath,'Working')); % JHB
                    
					[~,order] = sort([valid_wfs(:).datenum]); % JHB
					working_names = {valid_wfs(order).name}; % JHB
					last_file = working_names{end};
					number_start = regexp(last_file,'\([0-9]+\)') + 1;
					last_number = str2num(last_file(number_start:end-5));
					next_number = last_number + 1;
					valid_name = [SNOB.name(1:number_start-1),num2str(next_number),')']; % JHB
				else
					valid_name = [SNOB.name,'(1)'];
				end
			end
        else
            % JHB - this checks to see if the folder has been cleared 
            wfs = dir(fullfile(SNOB.filepath, 'Working'));
            numbered_exists = false;
            n_valid = 0;
            for i = 1:length(wfs)
                if ~ismember(wfs(i).name,{'.','..','.DS_Store'}) % this deals with Mac layout files (which updates frequently and may be the last file)
                    numbered_exists = ~isempty(regexp(wfs(i).name,'(\d)','Once')) | numbered_exists;
                    n_valid = n_valid + 1;
                    valid_wfs(n_valid) = wfs(i);
                end
            end
            
            if ~n_valid % JHB - if no files cut off the counter
                if regexp(SNOB.name,'(\d)')
                    ob = regexp(SNOB.name,'(');
                    last_ob = max(ob);
                    valid_name = SNOB.name(1:last_ob-1);
                end
            else
                valid_name = SNOB.name;
            end	
		end

		if ~strcmp(valid_name,SNOB.name) && ~isempty(valid_name)
			SNOB.name = valid_name;
			fprintf('Name changed to %s to prevent naming conflict!\r\n',valid_name) % JHB - removed , & added \r
		end
	end

end

