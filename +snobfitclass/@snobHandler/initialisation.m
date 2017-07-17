function initialisation(SNOB,src,event)

	if size(SNOB.x_upper,2) > size(SNOB.x_upper,1)
		SNOB.x_upper = SNOB.x_upper';
	end

	if size(SNOB.x_lower,2) > size(SNOB.x_lower,1)
		SNOB.x_lower = SNOB.x_lower';
	end

	if ~isempty(SNOB.x_upper) & (size(SNOB.x_lower) == size(SNOB.x_upper))
		if strcmp(SNOB.fcn,'none')
			fprintf(2,'Do not forget to set the function!\n');
		else
			SNOB.n = length(SNOB.x_lower);
			SNOB.nreq = SNOB.n + 4;
			SNOB.npoint = SNOB.n + 4;

			SNOB.dx = (SNOB.x_upper - SNOB.x_lower)'*1e-3; %'
			SNOB.minimised = false;
			if ~strcmp(SNOB.status,'initialised')
				SNOB.status = 'initialised';
				notify(SNOB, 'StatusChange');
			end
		end
	end
end