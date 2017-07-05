function checkName(SNOB)

% only check if the name is valid when the experiment is started, as could cause
% conflict with other parameters

valid_name = '';

if ~SNOB.continuing
    
    % check if working file already exists
    working_exists = exist(fullfile(SNOB.filepath,'Working',[SNOB.name,'.mat']),'file');
    
    % check if Results folder already exists
    results_exists = isdir(fullfile(SNOB.filepath,'Results',SNOB.name));
    
    if (working_exists || results_exists)
        
        % find base file name
        if ~isempty(regexp(SNOB.name,'(\d)','Once'))
            % SNOB.name has a number extension - trim from end
            base_name = SNOB.name(1:regexp(SNOB.name,'\([0-9]+\)')-1);
        else
            base_name = SNOB.name;
        end
        
        % get list of working files
        wfs = dir(fullfile(SNOB.filepath, 'Working'));
        
        highest_num = 0;
        
        for i = 1:length(wfs)
            if ~ismember(wfs(i).name,{'.','..','.DS_Store'}) && length(wfs(i).name) >= length(base_name)
                % check to see if base names match
                if strcmp(wfs(i).name(1:length(base_name)),base_name)
                    if ~isempty(regexp(wfs(i).name,'(\d)','Once'))
                        % enumerated filename - find number
                        num = str2double(wfs(i).name(regexp(wfs(i).name,'\([0-9]+\)')+1:end-5));
                        if num > highest_num
                            highest_num = num;
                            SNOB.name = wfs(i).name(1:end-4);
                        end
                    end
                end
            end
        end
        
        % get list of results files
        rfs = dir(fullfile(SNOB.filepath, 'Results'));
        
        for i = 1:length(rfs)
            if ~ismember(rfs(i).name,{'.','..','.DS_Store'}) && length(rfs(i).name) >= length(base_name)
                if strcmp(rfs(i).name(1:length(base_name)),base_name)
                    if ~isempty(regexp(rfs(i).name,'(\d)','Once'))
                        num = str2double(rfs(i).name(regexp(rfs(i).name,'\([0-9]+\)')+1:end-1));
                        if num > highest_num
                            highest_num = num;
                            SNOB.name = rfs(i).name;
                        end
                    end
                end
            end
        end
        
        
        
        % get a list of all numbered files if they exist
        if highest_num
            valid_name = [SNOB.name(1:regexp(SNOB.name,'\([0-9]+\)')),num2str(highest_num+1),')']; % JHB
        else
            valid_name = [SNOB.name,'(1)'];
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

