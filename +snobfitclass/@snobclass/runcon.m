function runcon(SNOB)

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

	if isempty(SNOB.xstart)
		x = rand(SNOB.npoint,SNOB.n);
		x = x*diag(SNOB.x_upper - SNOB.x_lower) + ones(SNOB.npoint,1)*SNOB.x_lower';
	else
		x = rand(SNOB.npoint-1,SNOB.n);
		x = x*diag(SNOB.x_upper - SNOB.x_lower) + ones(SNOB.npoint-1,1)*SNOB.x_lower';
		x = [SNOB.xstart;x];
	end

	for i = 1:SNOB.npoint
		x(i,:) = snobround(x(i,:),SNOB.x_lower',SNOB.x_upper',SNOB.dx);
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
	if size(f, 2) > size(f, 1)
		error('Your objective function must return a column vector, it is returning a row vector or a scalar')
	end

	F = feval(['snobfitclass.confcn.',SNOB.constraintFcn],SNOB);
	if size(F, 1) ~= SNOB.npoint && size(F, 2) ~= length(SNOB.F_upper)
		error('Each constraint must be returned as a column in F, you have returned them as rows')
	end

	isvalid = all(repmat(SNOB.F_lower', SNOB.npoint, 1) <= F & F <= repmat(SNOB.F_upper', SNOB.npoint, 1), 2);
	if any(isvalid)
		SNOB.f0 = min(f(isvalid));
		SNOB.feasiblePointFound = true;
	else
		SNOB.f0 = 2 * max(f) - min(f);
	end

	SNOB.isFeasible = isvalid;

	SNOB.Delta = median(abs(f(~isnan(f)) - SNOB.f0));
	for i = 1:SNOB.npoint
		fm(i,1) = softmerit(f(i),F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,...
							SNOB.Delta,SNOB.sigmaUpper,SNOB.sigmaLower);
	end
	fm(:,2) = sqrt(eps);

	SNOB.x = x;
	SNOB.f = f;
	SNOB.F = F;
	SNOB.fm = fm(:,1);

	SNOB.ncall0 = SNOB.ncall0 + length(f);
	params = struct('bounds',{SNOB.x_lower,SNOB.x_upper},'nreq',SNOB.nreq,'p',SNOB.p);

	while stop_condition == 0
		if SNOB.ncall0 == SNOB.npoint
			[request,xbest,fbest] = snobfit(working_file, x_old, fm, params, SNOB.dx);

			SNOB.xbest = xbest;
			SNOB.fbest = fbest;
			[~,jbest] = min(SNOB.fm);
            SNOB.fbestHistory = [jbest]

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
		F = feval(['snobfitclass.confcn.',SNOB.constraintFcn],SNOB);

		fm = zeros(size(f));
		for i = 1:SNOB.nreq
			fm(i,1) = softmerit(f(i),F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,...
								SNOB.Delta,SNOB.sigmaUpper,SNOB.sigmaLower);
		end
		fm(:,2) = sqrt(eps);

		SNOB.x = [SNOB.x;x];
		SNOB.f = [SNOB.f;f];
		SNOB.F = [SNOB.F;F];
		SNOB.fm = [SNOB.fm;fm(:,1)];
		SNOB.ncall0 = SNOB.ncall0 + length(f);

		[SNOB.fbest,jbest] = min(SNOB.fm);
		SNOB.xbest = SNOB.x(jbest,:);
		SNOB.fbestHistory = [SNOB.fbestHistory; jbest];

		isvalid = all(repmat(SNOB.F_lower', SNOB.npoint, 1) <= F & F <= repmat(SNOB.F_upper', SNOB.npoint, 1), 2);
		if any(isvalid)
			SNOB.feasiblePointFound = true;
		end

		SNOB.isFeasible = [SNOB.isFeasible; isvalid];

		notify(SNOB, 'DataToPlot');
		notify(SNOB, 'DataToPrint');

		stop_condition = SNOB.checkTermination();		

		if SNOB.fbest < 0 & change == 0
			K = size(SNOB.x,1);
			ind = find(min(SNOB.F - ones(K,1)*SNOB.F_lower',[],2) > -eps & min(ones(K,1)*SNOB.F_upper' - SNOB.F,[],2) > -eps);
			if ~isempty(ind)
				change = 1;
				SNOB.f0 = min(SNOB.f(ind));
				SNOB.Delta = median(abs(SNOB.f(~isnan(SNOB.f)) - SNOB.f0));

				fm = zeros(K,1);
				for i = 1:K
					fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,...
										SNOB.Delta,SNOB.sigmaUpper,SNOB.sigmaLower);
				end
				fm(:,2) = sqrt(eps);

				x_old = SNOB.xVirt;
				SNOB.fm = fm(:,1);
			end
		end

		pause(SNOB.plot_delay);

	end

end