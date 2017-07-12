function runsoft(SNOB)

	import snobfitclass.snobfcn.*

	% JHB ADDED - CREATES THE WORKING DIR
    if ~isdir(fullfile(SNOB.filepath, 'Working')) % full file is platform independent
        mkdir(fullfile(SNOB.filepath, 'Working'))
    end

	% specify path to working file
	working_file = fullfile(SNOB.filepath,'Working',SNOB.name); % JHB - platform independent folder naming

	stop_condition = 0;
	SNOB.ncall0 = 0;
	change = 0;

	x = rand(SNOB.npoint-1,SNOB.n);
	x = x*diag(SNOB.v - SNOB.u) + ones(SNOB.npoint-1,1)*SNOB.u';
	x = [SNOB.xstart;x];

	for i = 1:SNOB.npoint
		x(i,:) = snobround(x(i,:),SNOB.u',SNOB.v',SNOB.dx);
	end

	x_old = x;

	if SNOB.linked
		[xx1,xx2] = snobfitclass.SquareToTrapezoid(x(:,1),x(:,2),SNOB.trapezoid);
		x = [xx1,xx2];
		if SNOB.n > 2
			x = [x,x_old(:,3:end)];
		end
	end

	SNOB.next = x;

	f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
	F = feval(['snobfitclass.confcn.',SNOB.softfcn],SNOB);

	isvalid = find(sum(repmat(SNOB.F_lower',SNOB.npoint,1) <= F & F <= repmat(SNOB.F_upper',SNOB.npoint,1)));
	if ~isempty(isvalid)
		SNOB.f0 = min(f(isvalid));
	else
		SNOB.f0 = 2 * max(f) - min(f);
	end

	SNOB.Delta = median(abs(f - SNOB.f0));

	for i = 1:SNOB.npoint
		fm(i,1) = softmerit(f(i),F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
	end
	fm(:,2) = sqrt(eps);

	SNOB.x = x;
	SNOB.f = f;
	SNOB.F = F;
	SNOB.fm = fm(:,1);

	SNOB.ncall0 = SNOB.ncall0 + length(f);
	params = struct('bounds',{SNOB.u,SNOB.v},'nreq',SNOB.nreq,'p',SNOB.p);

	while stop_condition == 0
		if SNOB.ncall0 == SNOB.npoint
			[request,xbest,fbest] = snobfit(working_file, x_old, fm, params, SNOB.dx);

			SNOB.xbest = xbest;
			SNOB.fbest = fbest;

			notify(SNOB, 'DataToPlot');
			notify(SNOB, 'DataToPrint');
		else
			[request,xbest,fbest] = snobfit(working_file, x_old, fm, params);
		end

		x = request(:,1:SNOB.n);
		x_old = x;

		if SNOB.linked
			[xx1,xx2] = snobfitclass.SquareToTrapezoid(x(:,1),x(:,2),SNOB.trapezoid);
			x = [xx1,xx2];
			if SNOB.n > 2
				x = [x,x_old(:,3:end)];
			end
		end

		SNOB.next = x;

		f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
		F = feval(['snobfitclass.confcn.',SNOB.softfcn],SNOB);

		fm = zeros(size(f));
		for i = 1:SNOB.nreq
			fm(i,1) = softmerit(f(i),F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
		end
		fm(:,2) = sqrt(eps);

		SNOB.x = [SNOB.x;x];
		SNOB.f = [SNOB.f;f];
		SNOB.F = [SNOB.F;F];
		SNOB.fm = [SNOB.fm;fm(:,1)];
		SNOB.ncall0 = SNOB.ncall0 + length(f);

		[SNOB.fbest,jbest] = min(SNOB.fm);
		SNOB.xbest = SNOB.x(jbest,:);

		notify(SNOB, 'DataToPlot');
		notify(SNOB, 'DataToPrint');

		stop_condition = SNOB.checkTermination();

		if SNOB.fbest < 0 & change == 0
			K = size(SNOB.x,1);
			ind = find(min(SNOB.F - ones(K,1)*SNOB.F_lower',[],2) > -eps & min(ones(K,1)*SNOB.F_upper' - SNOB.F,[],2) > -eps);
			if ~isempty(ind)
				change = 1;
				SNOB.f0 = min(SNOB.f(ind));
				SNOB.Delta = median(abs(SNOB.f - SNOB.f0));

				fm = zeros(K,1);
				for i = 1:K
					fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
				end
				fm(:,2) = sqrt(eps);

				x = SNOB.x;
			end
		end

		pause(SNOB.plot_delay);

	end

end