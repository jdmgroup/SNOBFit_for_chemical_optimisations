function runsnob(SNOB)
	
	import snobfitclass.snobfcn.*
    
    % JHB ADDED - CREATES THE WORKING DIR
    if ~isdir(fullfile(SNOB.filepath, 'Working')) % full file is platform independent
        mkdir(fullfile(SNOB.filepath, 'Working'))
    end

	% specify path to working file
	working_file = fullfile(SNOB.filepath,'Working',SNOB.name); % JHB - platform independent folder naming
    

    
	stop_condition = 0;

	if ~SNOB.continuing
		SNOB.ncall0 = 0;

		x = rand(SNOB.nreq,SNOB.n);	% Generate random starting points
		x = x*diag(SNOB.v - SNOB.u) + ones(SNOB.npoint,1)*SNOB.u';	% Map points to parameter range

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

		f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);		% Evaluate fcn at x
		f(:,2) = SNOB.uncert;		% Add uncertainty column

		SNOB.x = x;					% Store investigated points and values
		SNOB.f = f(:,1);
		SNOB.xVirt = x_old;

		SNOB.ncall0 = SNOB.ncall0 + length(f);
	else
		x_old = SNOB.xVirt;
		f = SNOB.f;
		f(:,2) = SNOB.uncert;
		x = SNOB.x;
	end

	params = struct('bounds',{SNOB.u,SNOB.v},'nreq',SNOB.nreq,'p',SNOB.p);		% Make parameters input for snobfit
	while stop_condition == 0

		% While loop to continuously call snobfit and evaluate fcn, until either minimum is found or ncall exceeded

		if SNOB.ncall0 == SNOB.npoint
			% if it is the first call to snobfit, include precision parameter
			[request,xbest,fbest] = snobfit(working_file, x_old, f, params, SNOB.dx);

			SNOB.xbest = xbest;
			SNOB.fbest = fbest;

			% print and plot results from starting point
			notify(SNOB, 'DataToPlot');
			notify(SNOB, 'DataToPrint');
		else
			[request,xbest,fbest] = snobfit(working_file,x_old,f,params);
		end

		% extract recommmended next points from snobfit output
		x = request(:,1:SNOB.n);
		x_old = x;

		% convert points to real space if needed
		if SNOB.linked
			[xx1,xx2] = snobfitclass.SquareToTrapezoid(x(:,1),x(:,2),SNOB.trapezoid);
			x = [xx1,xx2];
			if SNOB.n > 2
				x = [x,x_old(:,3:end)];
			end
		end

		SNOB.next = x;

		% Evaluate function at recommmended points, and store info
		f = feval(['snobfitclass.objfcn.',SNOB.fcn],SNOB);
		f(:,2) = SNOB.uncert;

		SNOB.x = [SNOB.x;x];
		SNOB.f = [SNOB.f;f(:,1)];
		SNOB.xVirt = [SNOB.xVirt;x_old];

		SNOB.ncall0 = SNOB.ncall0 + length(f);

		% calculate difference between expected minimum and all evaluated points, find best so far
		[fdiff,jbest] = min(abs(SNOB.fglob - SNOB.f));
		SNOB.fbest = SNOB.f(jbest,:);
		SNOB.xbest = SNOB.x(jbest,:);

		notify(SNOB, 'DataToPlot');
		notify(SNOB, 'DataToPrint');

		% Check if global mimimum found
		stop_condition = SNOB.checkTermination();

		pause(1);

	end

end