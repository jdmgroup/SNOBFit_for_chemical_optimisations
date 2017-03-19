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
                    [~,~,filetype] = fileparts(wfs(i).name);
                    if strcmp(filetype,'.mat') % this deals with Mac layout files (which updates frequently and may be the last file)
                        n_valid = n_valid + 1;
                        valid_wfs(n_valid) = wfs(i);
                    end
                end
                
                base_exists = false;
                numbered_exists = false;
                
                
                if ~isempty(regexp(SNOB.name,'(\d)'))
                    base_name = SNOB.name(1:max(regexp(SNOB.name,'('))-1);
                else
                    base_name = SNOB.name;
                end
                
                n_base = 0;
                for i = 1:length(valid_wfs)
                    if ~isempty(regexp(valid_wfs(i).name,'(\d)'))
                        isbase = strcmp(valid_wfs(i).name(1:max(regexp(valid_wfs(i).name,'('))-1),base_name);
                    else
                        isbase = strcmp(valid_wfs(i).name(1:end-4),base_name);
                    end
                    
                    if isbase
                        n_base = n_base + 1;
                        base_wfs(n_base) = valid_wfs(i);
                        base_exists = true;
                        if ~isempty(regexp(valid_wfs(i).name,'(\d)'))
                            numbered_exists = true;
                        end
                    end
                end
                
				%JHB - numbered_exists = exist(fullfile(SNOB.filepath,'Working',SNOB.name,'(1).mat')); % JHB

				% get a list of all numbered files if they exist
				if numbered_exists && n_base && base_exists % JHB
					% JHB - working_extant = dir(fullfile(SNOB.filepath,'Working')); % JHB
                    
					[~,order] = sort([base_wfs(:).datenum]); % JHB
					working_names = {base_wfs(order).name}; % JHB
					last_file = working_names{end};
					number_start = max(regexp(last_file,'(')) + 1;
					last_number = str2num(last_file(number_start:end-5));
					next_number = last_number + 1;
					valid_name = [SNOB.name(1:number_start-1),num2str(next_number),')']; % JHB
				else
					valid_name = [SNOB.name,'(1)'];
				end
            
        
        else
            % JHB - this checks to see if the results folder has been cleared 
            rfs = dir(fullfile(SNOB.filepath, 'Results'));
            
            if ~isempty(regexp(SNOB.name,'(\d)'))
                    base_name = SNOB.name(1:max(regexp(SNOB.name,'('))-1);
            else
                    base_name = SNOB.name;
            end
            
            numbered_exists = false;
            n_base = 0;
            for i = 1:length(rfs)
                if rfs(i).isdir && ~isempty(strcmp(rfs(i).name,{'.','..','.DS_Store'}))
                    if regexp(rfs(i).name,'(\d)')
                        isbase = strcmp(rfs(i).name(1:max(regexp(rfs(i).name,'('))-1),base_name);
                    else
                        isbase = strcmp(rfs(i).name,base_name);
                    end
                    
                    if isbase
                        if regexp(rfs(i).name,'(\d)')
                            numbered_exists = true;
                        end
                        n_base = n_base + 1;
                        base_rfs(n_base) = rfs(i);
                    end   
                end
            end
            
            if ~n_base % JHB - if no files in results foldercut off the counter
                if regexp(SNOB.name,'(\d)')
                    ob = max(regexp(SNOB.name,'('));
                    valid_name = SNOB.name(1:ob-1);
                end
            else
                % there is something with the current base in the folder
                [~,order] = sort([base_rfs(:).datenum]); % JHB
					working_names = {base_rfs(order).name}; % JHB
					last_file = working_names{end};
					number_start = max(regexp(last_file,'(')) + 1;
					last_number = str2num(last_file(number_start:end-1));
					next_number = last_number + 1;
					valid_name = [SNOB.name(1:number_start-1),num2str(next_number),')']; % JHB
                %valid_name = SNOB.name;
            end
                
		end

		
    end
    if ~strcmp(valid_name,SNOB.name) && ~isempty(valid_name)
			SNOB.name = valid_name;
			fprintf('Name changed to %s to prevent naming conflict!\r\n',valid_name) % JHB - removed , & added \r
		end

end

