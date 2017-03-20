function changeStatus(SNOB)
	
	switch SNOB.status
		case 'initialised'
			fprintf('SNOBFIT experiment has been created!\r\n');
		case 'running'
			fprintf('SNOBFIT experiment is running...\r\n');
		case 'complete'
			if SNOB.minimised
				fprintf('SNOBFIT experiment has finished, and a minimum was found!\r\n');
			else
				fprintf('SNOBFIT experiment has finished, ')
				fprintf(2,'BUT NO MIMIMUM WAS FOUND :(\r\n');
			end

			SNOB.saveExp;
		otherwise
			error('Not a recognised status!')
		end
end