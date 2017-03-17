function runcombo2(SNOB)

	import snobfitclass.snobfcn.*

	% specify path to working file
	working_file = [SNOB.filepath,'/Working/',SNOB.name];

	SNOB.ncall0 = 0;
	change = 0;

	% generate random starting points
	x = rand(SNOB.npoint-1,SNOB.n);
	x = x*diag(SNOB.v - SNOB.u) + ones(SNOB.npoint-1,1)*SNOB.u';
	x = [SNOB.xstart;x];

	% round points to snobfit grid
	for i = 1:SNOB.npoint
		x(i,:) = snobround(x(i,:),SNOB.u',SNOB.v',SNOB.dx);
	end

	x_old = x;

	% if parameters are linked, convert to real space
	if SNOB.linked
		[xx1,xx2] = snobfitclass.SquareToTrapezoid(x(:,1),x(:,2),SNOB.trapezoid);
		x = [xx1,xx2];
		if SNOB.n > 2
			x = [x,x_old(:,3:end)];
		end
	end

	SNOB.next = x;

	% evaluate objective and constraint functions
	f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
	F = feval(['snobfitclass.confcn.',SNOB.softfcn],SNOB);
 
	% store values
	SNOB.x = x;
	SNOB.xVirt = x_old;
	SNOB.f = f;
	SNOB.F = F;
	SNOB.ncall0 = SNOB.ncall0 + length(f);

	% check if there are any valid points
	isvalid = find(sum(repmat(SNOB.F1',SNOB.npoint,1) <= F & F <= repmat(SNOB.F2',SNOB.npoint,1)));

	params = struct('bounds',{SNOB.u,SNOB.v},'nreq',SNOB.nreq,'p',SNOB.p); 
	Fdiff = [];

	% if the upper bound is infinity, just set target to 0
	if any(isinf(SNOB.F2))
		snob_target = SNOB.F1';
	else
		% otherwise set it to the midpoint of the bounds
		snob_target = SNOB.F1' + abs(SNOB.F2' - SNOB.F1')/2; %'
	end

	% enter loop until valid points are found
	fprintf('finding f0 by SNOBFit...\n')
	while isempty(isvalid)
		% want to minimise the difference between F and the mid-point of the bounds
		%Fdiff = sum(abs(repmat(snob_target,length(f),1)-F),2);
		%Fdiff(:,2) = sqrt(eps);
        F(:,2) = sqrt(eps);
		% call snobfit to recommend points
		if SNOB.ncall0 == SNOB.npoint
			[request,xbest,fbest] = snobfit(working_file, x_old, F, params, SNOB.dx);
		else
			[request,xbest,fbest] = snobfit(working_file, x_old, F, params);
		end

		% extract recommended points
		x = request(:,1:SNOB.n);
		x_old = x;

		% if the parameters are linked, convert x to real space
		if SNOB.linked
			[xx1,xx2] = snobfitclass.SquareToTrapezoid(x(:,1),x(:,2),SNOB.trapezoid);
			x = [xx1,xx2];
			if SNOB.n > 2
				x = [x,x_old(:,3:end)];
			end
		end

		SNOB.next = x;

		% evaluate objective and constraint functions
		f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
		F = feval(['snobfitclass.confcn.',SNOB.softfcn],SNOB);

		% store values

		SNOB.x = [SNOB.x;x];
		SNOB.f = [SNOB.f;f];
		SNOB.F = [SNOB.F;F];
		SNOB.xVirt = [SNOB.xVirt;x_old];
		SNOB.ncall0 = SNOB.ncall0 + length(f);

		% check if there are any valid points
		isvalid = find(sum(repmat(SNOB.F1',SNOB.npoint,1) <= F & F <= repmat(SNOB.F2',SNOB.npoint,1)));
		
		% if the number of desired runs has been exceeded, stop
		if SNOB.ncall0 > SNOB.ncall./3
			fprintf('SNOBFit was unable to find a feasible starting point!\n')
			break;
		end
	end

	% increase the total desired function calls to those already done, plus the desired count
	%SNOB.ncall = SNOB.ncall0 + SNOB.ncall;

	% assing f0 as the minimum valid value of f
	if isempty(isvalid)
		% if a valid value of f was not found, go for the on that minimises F
		Fdiff = sum(abs(repmat(snob_target,length(SNOB.f),1)-SNOB.F),2);
		[~,minF_i] = min(Fdiff);
		f0 = SNOB.f(minF_i)
	else
		f0 = min(f(isvalid));
	end

	Delta = median(abs(f - f0))

	% calculate softmerit for all points looked at already
	fm = zeros(length(SNOB.f),1);
	for i = 1:length(SNOB.f)
		fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F1,SNOB.F2,f0,Delta,SNOB.sigma);
	end
	fm(:,2) = sqrt(eps);

	SNOB.fm = fm(:,1);

	x_old = SNOB.xVirt;

	% enter the soft SNOBFit portion
	while SNOB.ncall0 < SNOB.ncall
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
			fm(i,1) = softmerit(f(i),F(i,:),SNOB.F1,SNOB.F2,f0,Delta,SNOB.sigma);
		end
		fm(:,2) = sqrt(eps);

		SNOB.x = [SNOB.x;x];
		SNOB.xVirt = [SNOB.xVirt;x_old]
		SNOB.f = [SNOB.f;f];
		SNOB.F = [SNOB.F;F];
		SNOB.fm = [SNOB.fm;fm(:,1)];
		SNOB.ncall0 = SNOB.ncall0 + length(f);

		[SNOB.fbest,jbest] = min(SNOB.fm);
		SNOB.xbest = SNOB.x(jbest,:);

		notify(SNOB, 'DataToPlot');
		notify(SNOB, 'DataToPrint');

		in_lower = min(SNOB.F' - repmat(SNOB.F1,1,length(SNOB.F)) + repmat(SNOB.sigma,1,length(SNOB.F)),2)';
		in_upper = min(repmat(SNOB.F2,1,length(SNOB.F)) + repmat(SNOB.sigma,1,length(SNOB.F))- SNOB.F',2)';

		issoft = find(SNOB.f <= SNOB.fglob & in_lower >= 0 & in_upper >= 0);
		if ~isempty(issoft)
			SNOB.xsoft = SNOB.x(issoft,:);
			SNOB.minimised = true;
			break;
		end

		if SNOB.fbest < 0 & change == 0
			K = size(SNOB.x,1);
			ind = find(min(SNOB.F - ones(K,1)*SNOB.F1',[],2) > -eps & min(ones(K,1)*SNOB.F2' - SNOB.F,[],2));
			if ~isempty(ind)
				change = 1;
				f0 = min(SNOB.f(ind));
				Delta = median(abs(SNOB.f - f0));

				fm = zeros(K,1);
				for i = 1:K
					fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F1,SNOB.F2,f0,Delta,SNOB.sigma);
				end
				fm(:,2) = sqrt(eps);
				
				x_old = SNOB.xVirt;
				SNOB.fm = fm(:,1);
			end
		end

		pause(2);

	end

end