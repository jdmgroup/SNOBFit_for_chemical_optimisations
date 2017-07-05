function saveExp(SNOB)
	% Method to save snobfit experiment object, and a summary text file

	% Make sure the experiment has a name
	if isempty(SNOB.name)
		SNOB.name = 'untitled';
	end

	% Create folder with the experiment name
	savepath = fullfile(SNOB.filepath,'Results',SNOB.name); % JHB
	if ~isdir(savepath)
		mkdir(savepath);
    end

    % JHB - BAZ THIS WILL LIKELY CAUSE SIMILAR ISSUES TO CHECK NAME
    % CANT ASSUME THAT LAST FILE ISN'T ONE OF THE MAC DIR FILES
	if SNOB.continuing
		cont_files = dir(fullfile(savepath, SNOB.name,'_cont(*).mat')); % JHB
		if isempty(cont_files)
			filename = [SNOB.name,'_cont(1)'];
		else
			[~,order] = sort([cont_files(:).datenum]);
			cont_names = {cont_files(order).name};
			last_file = cont_names{end};
			number_start = regexp(last_file,'\([0-9]+\)') + 1;
			last_number = str2num(last_file(number_start:end-5));
			next_number = last_number + 1;
			filename = [SNOB.name,'_cont(',num2str(next_number),')'];
		end
	else
		filename = SNOB.name;
	end

	% Save object
	save(fullfile(savepath,filename),'SNOB'); % JHB

	% Check that the experiment has been run
	if ~isempty(SNOB.x)
		% Save a results file containing all investigated points and their value
		hdrs = '';
		for i = 1:SNOB.n
			hdrs = [hdrs, 'x',num2str(i),','];
		end
		results = [SNOB.x];

		if SNOB.linked
			results = [results, SNOB.xVirt];
			for i = 1:SNOB.n
				hdrs = [hdrs,'v',num2str(i),','];
			end
		end
		
		if SNOB.soft | SNOB.combo
			results = [results, SNOB.fm, SNOB.f, SNOB.F];
			hdrs  = [hdrs,'f,fobj,'];
			for i = 1:size(SNOB.F,2)
				hdrs = [hdrs,'fcon',num2str(i),','];
			end
			hdrs = [hdrs(1:end-1),'\n'];
		else
			hdrs = [hdrs,'f\n'];
			results = [results, SNOB.f];
		end
		format = '';
		for i = 1:size(results,2)
			format = [format,'%f,'];
		end
		format = [format(1:end-1),'\n'];

		fid = fopen(fullfile(savepath,[filename,'.results.csv']),'wt'); % JHB
		fprintf(fid,hdrs);
		for i = 1:size(results,1)
			fprintf(fid,format,results(i,:));
		end
		fclose(fid);

		% Save a text summary of the experiment with the setup and best point
		hdrs = 'Experiment,Created,Function,Method,';
		summary_str = sprintf('%s,%s,%s,',SNOB.name,SNOB.created,SNOB.fcn);
		if SNOB.soft
			summary_str = [summary_str,'soft,'];
		elseif SNOB.combo
			summary_str = [summary_str,'combo,'];
		else
			summary_str = [summary_str,'normal,'];
		end

		if SNOB.soft | SNOB.combo
			hdrs = [hdrs,'softfcn,softstart,'];
			summary_str = [summary_str,sprintf('%s,%d,',SNOB.softfcn,SNOB.softstart)];
			for i = 1:length(SNOB.sigma)
				hdrs = [hdrs,sprintf('sigma%d,',i)];
				summary_str = [summary_str,sprintf('%f,',SNOB.sigma(i))];
			end
			for i = 1:length(SNOB.F1)
				hdrs = [hdrs,sprintf('F1_%d,',i)];
				if isinf(SNOB.F1)
					summary_str = [summary_str,sprintf('%s,','-inf')];
				else
					summary_str = [summary_str,sprintf('%f,',SNOB.F1(i))];
				end
			end
			for i = 1:length(SNOB.F2)
				hdrs = [hdrs,sprintf('F2_%d,',i)];
				if isinf(SNOB.F2(i))
					summary_str = [summary_str,sprintf('%s,','inf')];
				else
					summary_str = [summary_str,sprintf('%f,',SNOB.F2(i))];
				end
			end
		end

		hdrs = [hdrs,'linked,'];
		summary_str = [summary_str,sprintf('%d,',double(SNOB.linked))];
		if SNOB.linked
			hdrs = [hdrs,'xyMax,xyMin,maxRatio,minRatio,zMax,zMin,'];
			summary_str = [summary_str,sprintf('%f,%f,%f,%f,%f,%f,',SNOB.xyMax,SNOB.xyMin,...
												SNOB.maxRatio,SNOB.minRatio,SNOB.zMax,SNOB.zMin)];
		end

		hdrs = [hdrs,'ncall,ncalled,'];
		summary_str = [summary_str,sprintf('%d,%d,',SNOB.ncall,SNOB.ncall0)];
		for i = 1:SNOB.n
			hdrs = [hdrs,'xbest',num2str(i),','];
			if SNOB.combo | SNOB.soft
				if length(SNOB.xsoft) > 0:
					summary_str = [summary_str,sprintf('%f,',SNOB.xsoft(i))];
				end
			else
				summary_str = [summary_str,sprintf('%f,',SNOB.xbest(i))];
			end
		end
		hdrs = [hdrs,'fbest\n'];
		summary_str = [summary_str,sprintf('%f\n',SNOB.fbest)];
		if length(SNOB.xsoft) > 0
			hdrs = [hdrs,'fsoft\n'];
			summary_str = [summary_str,sprintf('%f\n',SNOB.fsoft)];
		end


		fid = fopen(fullfile(savepath,[filename,'.csv']),'wt'); % JHB
		fprintf(fid,hdrs);
		fprintf(fid,summary_str);
		fclose(fid);
		
	end

end