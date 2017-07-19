function runcombo(SNOB)

	import snobfitclass.snobfcn.*

	% specify path to working file
	working_file = [SNOB.filepath,'/Working/',SNOB.name];

	stop_condition = 0;
    if ~SNOB.continuing
        SNOB.ncall0 = 0;
        change = 0;

        % generate random starting points      
        if isempty(SNOB.xstart)
            x = rand(SNOB.npoint,SNOB.n);
            x = x*diag(SNOB.x_upper - SNOB.x_lower) + ones(SNOB.npoint,1)*SNOB.x_lower';
        else
            x = rand(SNOB.npoint-1,SNOB.n);
            x = x*diag(SNOB.x_upper - SNOB.x_lower) + ones(SNOB.npoint-1,1)*SNOB.x_lower';
            x = [SNOB.xstart;x];
        end

        % round points to snobfit grid
        for i = 1:SNOB.npoint
            x(i,:) = snobround(x(i,:),SNOB.x_lower',SNOB.x_upper',SNOB.dx);
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
    	if size(f, 2) > size(f, 1)
			error('Your objective function must return a column vector, it is returning a row vector or a scalar')
		end

        F = feval(['snobfitclass.confcn.',SNOB.constraintFcn],SNOB);
        if size(F, 1) ~= SNOB.npoint && size(F, 2) ~= length(SNOB.F_upper)
			error('Each constraint must be returned as a column in F, you have returned them as rows')
		end

        % store values
        SNOB.x = x;
        SNOB.xVirt = x_old;
        SNOB.f = f;
        SNOB.F = F;
        SNOB.ncall0 = SNOB.ncall0 + length(f);

        % check if there are any valid points
        isvalid = find(sum(repmat(SNOB.F_lower',SNOB.npoint,1) <= F & F <= repmat(SNOB.F_upper',SNOB.npoint,1),2) == length(SNOB.F_lower));
        params = struct('bounds',{SNOB.x_lower,SNOB.x_upper},'nreq',SNOB.nreq,'p',SNOB.p);

    else
        x_old = SNOB.xVirt;
		f = SNOB.f;
		F = SNOB.F;
		x = SNOB.x;
		isvalid = find(sum(repmat(SNOB.F_lower',length(F),1) <= F & F <= repmat(SNOB.F_upper',length(F),1),2) == length(SNOB.F_lower));
        params = struct('bounds',{SNOB.x_lower,SNOB.x_upper},'nreq',SNOB.nreq,'p',SNOB.p);
        change = 0;
    end
	% enter loop until valid points are found
    if ~SNOB.continuing | isinf(SNOB.f0)
        fprintf('finding f0 by SNOBFit...\n')
        while isempty(isvalid)
            % want to minimise the penalty on F
            above_bounds = SNOB.F - repmat(SNOB.F_upper', length(SNOB.F), 1);
            below_bounds = repmat(SNOB.F_lower', length(SNOB.F), 1) - SNOB.F;

            above_bounds(above_bounds <= 0) = 0;
            below_bounds(below_bounds <= 0) = 0;

            violation = sum(above_bounds.^2 ./ repmat(SNOB.sigma', length(SNOB.F), 1).^2, 2);
            violation = violation + sum(below_bounds.^2 ./ repmat(SNOB.sigma', length(SNOB.F), 1).^2, 2);

            penalty = 2 * violation ./ (1 + violation);

            penalty(:,2) = sqrt(eps);

            % call snobfit to recommend points
            if SNOB.ncall0 == SNOB.npoint
                [request,xbest,fbest] = snobfit(working_file, x_old, penalty, params, SNOB.dx);
            else
                [request,xbest,fbest] = snobfit(working_file, x_old, penalty, params);
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
            F = feval(['snobfitclass.confcn.',SNOB.constraintFcn],SNOB);

            % store values

            SNOB.x = [SNOB.x;x];
            SNOB.f = [SNOB.f;f];
            SNOB.F = [SNOB.F;F];
            SNOB.xVirt = [SNOB.xVirt;x_old];
            SNOB.ncall0 = SNOB.ncall0 + length(f);

            % check if there are any valid points
            isvalid = find(sum(repmat(SNOB.F_lower',SNOB.npoint,1) <= F & F <= repmat(SNOB.F_upper',SNOB.npoint,1),2) == length(SNOB.F_lower));

            % if the number of desired runs has been exceeded, stop
            if SNOB.ncall0 > SNOB.ncall./3
                fprintf('SNOBFit was unable to find a feasible starting point!\n')
                break;
            end
        end
        SNOB.conStart = SNOB.ncall0;

        % increase the total desired function calls to those already done, plus the desired count
        %SNOB.ncall = SNOB.ncall0 + SNOB.ncall;

        % assing f0 as the minimum valid value of f
        if isempty(isvalid)
            % if a valid value of f was not found, go for the on that minimises F
            Fdiff = sum(abs(repmat(snob_target,length(SNOB.f),1)-SNOB.F),2);
            [~,minF_i] = min(Fdiff);
            SNOB.f0 = SNOB.f(minF_i);
        else
            SNOB.f0 = min(f(isvalid));
        end
        fprintf('\nFound f0 as %f at call %d\n', SNOB.f0, SNOB.ncall0)
        SNOB.Delta = median(abs(f - SNOB.f0));
        fprintf('Found Delta as %f\n\n', SNOB.Delta)

        % calculate softmerit for all points looked at already
        fm = zeros(length(SNOB.f),1);
        for i = 1:length(SNOB.f)
            fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
        end
        fm(:,2) = sqrt(eps);

        SNOB.fm = fm(:,1);

        x_old = SNOB.xVirt;
    else
        fm = SNOB.fm;
        fm(:,2) = sqrt(eps);
    end

	% enter the constrained SNOBFit portion
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
		F = feval(['snobfitclass.confcn.',SNOB.constraintFcn],SNOB);

		fm = zeros(size(f));
		for i = 1:SNOB.nreq
			fm(i,1) = softmerit(f(i),F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
		end
		fm(:,2) = sqrt(eps);

		SNOB.x = [SNOB.x;x];
		SNOB.xVirt = [SNOB.xVirt;x_old];
		SNOB.f = [SNOB.f;f];
		SNOB.F = [SNOB.F;F];
		SNOB.fm = [SNOB.fm;fm(:,1)];
		SNOB.ncall0 = SNOB.ncall0 + length(f);

		[SNOB.fbest,jbest] = min(SNOB.fm);
		SNOB.xbest = SNOB.x(jbest,:);

		notify(SNOB, 'DataToPlot');
		notify(SNOB, 'DataToPrint');

		stop_condition = SNOB.checkTermination();

		if SNOB.fbest < 0 && change == 0
			K = size(SNOB.x,1);
			ind = find(min(SNOB.F - ones(K,1)*SNOB.F_lower',[],2) > -eps & min(ones(K,1)*SNOB.F_upper' - SNOB.F,[],2) > -eps);
			if ~isempty(ind)
				change = 1;
				SNOB.f0 = min(SNOB.f(ind));
				SNOB.Delta = median(abs(SNOB.f - SNOB.f0));
                fprintf('\nf0 changed to %f at call %d\n', SNOB.f0, SNOB.ncall0)
                fprintf('Delta changed to %f\n\n', SNOB.Delta)

				fm = zeros(K,1);
				for i = 1:K
					fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F_lower,SNOB.F_upper,SNOB.f0,SNOB.Delta,SNOB.sigma);
				end
				fm(:,2) = sqrt(eps);
				
				x_old = SNOB.xVirt;
				SNOB.fm = fm(:,1);
			end
		end

		pause(SNOB.plot_delay);

	end

end