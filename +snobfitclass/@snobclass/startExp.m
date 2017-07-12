function startExp(SNOB)
	
	import snobfitclass.snobfcn.*

	if isempty(SNOB.status)
		error('User must input setup parameters first!')
    end

	SNOB.status = 'running';
	notify(SNOB, 'StatusChange');
	if isempty(SNOB.name)
		SNOB.name = 'untitled';
	end

	notify(SNOB, 'StartingExp');
	
	if SNOB.soft & ~SNOB.combo
		SNOB.runsoft;
	elseif SNOB.combo
		SNOB.runcombo;
	else
		SNOB.runsnob;
	end
	if SNOB.repeatBest
		% evaluate the function again, at the best point to check consistency
		if SNOB.soft | SNOB.combo
			[fbest,jbest] = min(SNOB.fm);
		else
			[fbest,jbest] = min(SNOB.f);
		end
		x = SNOB.x(jbest,:);
		SNOB.next = x;

		f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
		if SNOB.soft | SNOB.combo
			F = feval(['snobfitclass.confcn.',SNOB.softfcn],SNOB);
			
			fm = softmerit(f,F,SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
			
			SNOB.F = [SNOB.F;F];
			SNOB.fm = [SNOB.fm;fm];
		end
			
		SNOB.x = [SNOB.x;x];
		SNOB.f = [SNOB.f;f];
		if SNOB.linked
			SNOB.xVirt = [SNOB.xVirt;SNOB.xVirt(jbest,:)];
		end

		SNOB.ncall0 = SNOB.ncall0 + length(f);

		%print out results
		fprintf('Repeat of xbest:\n')
		prnt = 'xbest:\t%f';
		for i = 1:SNOB.n-1
			prnt = [prnt,', %f'];
		end
		prnt = [prnt,'\n'];

		fprintf(prnt, x)
		fprintf('fbest:\t%f\r\n', f(:,1))
	
	end

	SNOB.status = 'complete';
	notify(SNOB, 'StatusChange');

end