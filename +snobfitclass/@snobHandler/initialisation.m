function initialisation(SNOB,src,event)

	if size(SNOB.v,2) > size(SNOB.v,1)
		SNOB.v = SNOB.v';
	end

	if size(SNOB.u,2) > size(SNOB.u,1)
		SNOB.u = SNOB.u';
	end

	if ~isempty(SNOB.v) & (size(SNOB.u) == size(SNOB.v))
		if strcmp(SNOB.fcn,'none')
			fprintf(2,'Do not forget to set the function!\n');
		else
			SNOB.n = length(SNOB.u);
			SNOB.nreq = SNOB.n + 4;
			SNOB.npoint = SNOB.n + 4;

			SNOB.dx = (SNOB.v - SNOB.u)'*1e-3; %'
			SNOB.minimised = false;
			if ~strcmp(SNOB.status,'initialised')
				SNOB.status = 'initialised';
				notify(SNOB, 'StatusChange');
			end
		end
	end
end