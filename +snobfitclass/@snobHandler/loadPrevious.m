function loadPrevious(SNOB,src,event)

	if strcmp(SNOB.name,'untitled') | isempty(SNOB.name)
		% if snobfit name is set to the default, don't do anything
	else

		if SNOB.continuing

			% check if working file already exists
			working_exists = exist(fullfile(SNOB.filepath,'Working',[SNOB.name,'.mat']),'file'); % JHB
			
			% check if Results folder already exists
			results_exists = isdir(fullfile(SNOB.filepath,'Results',SNOB.name)); % JHB
			
			if working_exists | results_exists
				if ~results_exists

					% if there isnt finished snobfit object, load it in from the working file
					old_snob = load(fullfile(SNOB.filepath,'Working',[SNOB.name,'.mat'])); % JHB

					% set values from previous experiment, if they havent been set already
					if isempty(SNOB.x)
						SNOB.x = old_snob.x;
						SNOB.f = old_snob.f;
						SNOB.x_lower = old_SNOB.x_lower;
						SNOB.x_upper = old_SNOB.x_upper;
						SNOB.xVirt = old_snob.x;

						% set ncall default
						SNOB.ncall = 200;
					end
				else
					% check if there are any numbered, already continued experiments
					cont_files = dir(fullfile(SNOB.filepath,'Results',SNOB.name,SNOB.name,'_cont(*).mat')); % JHB

					if ~isempty(cont_files)
						[~,order] = sort([cont_files(:).datenum]);
						cont_names = {cont_files(order).name};
						old_snob = load(fullfile(SNOB.filepath,'Results',SNOB.name,cont_names{end})); % JHB
					else
						old_snob = load(fullfile(SNOB.filepath,'Results',SNOB.name,SNOB.name,'.mat')); % JHB
					end

					% if there is a finished snobfit object, we can load some more variables
					if isempty(SNOB.x)
						SNOB.fcn = old_snob.SNOB.fcn;
						SNOB.x = old_snob.SNOB.x;
						SNOB.f = old_snob.SNOB.f;
						SNOB.n = old_snob.SNOB.n;
						SNOB.xVirt = old_snob.SNOB.xVirt;				
						
						SNOB.linked = old_snob.SNOB.linked;
						if SNOB.linked
							SNOB.xyMin = old_snob.SNOB.xyMin;
							SNOB.xyMax = old_snob.SNOB.xyMax;
							SNOB.zMin = old_snob.SNOB.zMin;
							SNOB.zMax = old_snob.SNOB.zMax;
							SNOB.minRatio = old_snob.SNOB.minRatio;
							SNOB.maxRatio = old_snob.SNOB.maxRatio;
						else
							SNOB.x_lower = old_snob.SNOB.x_lower;
							SNOB.x_upper = old_snob.SNOB.x_upper;
						end

						SNOB.constrained = old_snob.SNOB.constrained;
						if SNOB.constrained
							SNOB.F = old_snob.SNOB.F;
							SNOB.fm = old_snob.SNOB.fm;
						end

						SNOB.ncall = 200;
						SNOB.ncall0 = old_snob.SNOB.ncall0;
					end
				end

			else
				SNOB.continuing = false;
				fprintf(2,'There is no experiment to continue!\n')
				fprintf('Changed continuing setting to false\n')
			end

		end
	end
end
