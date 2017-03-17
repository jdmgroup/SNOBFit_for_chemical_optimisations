function runcombo(SNOB)

	import snobfitclass.snobfcn.*

	% specify path to working file
	working_file = [SNOB.filepath,'/Working/',SNOB.name];

	stop_condition = 0;
    if ~SNOB.continuing
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
        isvalid = find(sum(repmat(SNOB.F1',SNOB.npoint,1) <= F & F <= repmat(SNOB.F2',SNOB.npoint,1),2) == length(SNOB.F1));

        params = struct('bounds',{SNOB.u,SNOB.v},'nreq',SNOB.nreq,'p',SNOB.p); 
        Fdiff = [];

        % Set the target of the hard snobfit part to the lower bound
        snob_target = SNOB.F1'; %'
    else
        x_old = SNOB.xVirt;
		f = SNOB.f;
		F = SNOB.F;
		x = SNOB.x;
		isvalid = find(sum(repmat(SNOB.F1',length(F),1) <= F & F <= repmat(SNOB.F2',length(F),1),2) == length(SNOB.F1));
        params = struct('bounds',{SNOB.u,SNOB.v},'nreq',SNOB.nreq,'p',SNOB.p);
        change = 0;
    end
	% enter loop until valid points are found
    if ~SNOB.continuing | isinf(SNOB.f0)
        fprintf('finding f0 by SNOBFit...\n')
        while isempty(isvalid)
            % want to minimise the difference between F and the lower bounds
            Fdiff = sum(abs(repmat(snob_target,length(f),1)-F),2);
            Fdiff(:,2) = sqrt(eps);

            % call snobfit to recommend points
            if SNOB.ncall0 == SNOB.npoint
                [request,xbest,fbest] = snobfit(working_file, x_old, Fdiff, params, SNOB.dx);
            else
                [request,xbest,fbest] = snobfit(working_file, x_old, Fdiff, params);
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
            isvalid = find(sum(repmat(SNOB.F1',SNOB.npoint,1) <= F & F <= repmat(SNOB.F2',SNOB.npoint,1),2) == length(SNOB.F1));

            % if the number of desired runs has been exceeded, stop
            if SNOB.ncall0 > SNOB.ncall./3
                fprintf('SNOBFit was unable to find a feasible starting point!\n')
                break;
            end
        end
        SNOB.softstart = SNOB.ncall0;

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
            fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F1,SNOB.F2,SNOB.f0,SNOB.Delta,SNOB.sigma);
        end
        fm(:,2) = sqrt(eps);

        SNOB.fm = fm(:,1);

        x_old = SNOB.xVirt;
    else
        fm = SNOB.fm;
        fm(:,2) = sqrt(eps);
    end

	% enter the soft SNOBFit portion
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
			fm(i,1) = softmerit(f(i),F(i,:),SNOB.F1,SNOB.F2,SNOB.f0,SNOB.Delta,SNOB.sigma);
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

		stop_condition = SNOB.checkTermination();

		if SNOB.fbest < 0 && change == 0
			K = size(SNOB.x,1);
			ind = find(min(SNOB.F - ones(K,1)*SNOB.F1',[],2) > -eps & min(ones(K,1)*SNOB.F2' - SNOB.F,[],2) > -eps);
			if ~isempty(ind)
				change = 1;
				SNOB.f0 = min(SNOB.f(ind));
				SNOB.Delta = median(abs(SNOB.f - SNOB.f0));
                fprintf('\nf0 changed to %f at call %d\n', SNOB.f0, SNOB.ncall0)
                fprintf('Delta changed to %f\n\n', SNOB.Delta)

				fm = zeros(K,1);
				for i = 1:K
					fm(i,1) = softmerit(SNOB.f(i),SNOB.F(i,:),SNOB.F1,SNOB.F2,SNOB.f0,SNOB.Delta,SNOB.sigma);
				end
				fm(:,2) = sqrt(eps);
				
				x_old = SNOB.xVirt;
				SNOB.fm = fm(:,1);
			end
		end

		pause(1);

	end

end