function flag = checkTermination(SNOB)
	% Method to check if the termination condition has been met,
	% returns flag = 0 if not met, and flag = 1 if met
	
	flag = 0;

	switch SNOB.termination
		case 'minimised'
		% when the algorithm finds a minumum point, which is different depending on the method
			if SNOB.constrained | SNOB.combo
				% Check that the global minimum has been found,
				% and the constraints are satisfied
				in_lower = min(SNOB.F' - repmat(SNOB.F_lower,1,length(SNOB.F)) +...
								  repmat(SNOB.sigmaLower,1,length(SNOB.F)))';
				in_upper = min(repmat(SNOB.F_upper,1,length(SNOB.F)) +...
								  repmat(SNOB.sigmaUpper,1,length(SNOB.F))- SNOB.F')';

				feasible_points = find(SNOB.f <= SNOB.fglob+SNOB.threhold & in_lower >= 0 & in_upper >= 0);
				if ~isempty(feasible_points)
					[~,best_feasible] = min(SNOB.fm(feasible_points));
					SNOB.xcon = SNOB.x(feasible_points(best_feasible), :);
					SNOB.fcon = SNOB.f(feasible_points(best_feasible), 1);
					flag = 1;
				end

			else
				% Check that the global minimum has been found
				if SNOB.fglob
					if abs((SNOB.fglob - SNOB.fbest)/SNOB.fglob) < SNOB.threshold
						flag = 1;
					end
				else
					if abs(SNOB.fbest) < SNOB.threshold
						flag = 1;
					end
				end
			end

		case 'no_change'
		% when there is no change in a set number of previous points

			% store history of fbest
			if SNOB.ncall0 >= SNOB.minCalls
				SNOB.fbestHistory = [SNOB.fbestHistory;SNOB.fbest];
			end

			count = length(find(SNOB.fbestHistory == SNOB.fbest));

			if any(count >= SNOB.ncallNoChange)
				flag = 1;
				if SNOB.constrained | SNOB.combo
	
					delta = max(0,max(repmat(SNOB.F_lower',SNOB.ncall0,1) - SNOB.F, SNOB.F - repmat(SNOB.F_upper',SNOB.ncall0,1))./repmat(SNOB.sigma',SNOB.ncall0,1));%'
					feasible_points = find(max(delta,[],2) <= 1);
					if ~isempty(feasible_points)
						[fcon, icon] = min(SNOB.fm(feasible_points));
						SNOB.xcon = SNOB.x(icon,:);
					else
						delta0 = sum(delta.^2,2);
						[mindelta,icon] = min(delta0);
						SNOB.xcon = SNOB.x(icon,:);

						disp('WARNING: No feasible point has been found')
  						disp('xcon is the point with smallest constraint violation sum(delta_i^2');
					end
				end

			end
		case 'n_runs'
		
			if SNOB.ncall0 >= SNOB.ncall
				flag = 1;
				
				if SNOB.constrained | SNOB.combo
					% check for any feasible points
					in_lower = min(SNOB.F' - repmat(SNOB.F_lower,1,length(SNOB.F)) +...
									repmat(SNOB.sigmaLower,1,length(SNOB.F)))';
					in_upper = min(repmat(SNOB.F_upper,1,length(SNOB.F)) +...
									repmat(SNOB.sigmaUpper,1,length(SNOB.F))- SNOB.F')';

					feasible_points = find(SNOB.f <= SNOB.fglob+SNOB.threshold & in_lower >= 0 & in_upper >= 0);
					if ~isempty(feasible_points)
						[~,best_feasible] = min(SNOB.fm(feasible_points));
						SNOB.xcon = SNOB.x(feasible_points(best_feasible), :);
						SNOB.fcon = SNOB.f(feasible_points(best_feasible), 1);
					end
				end
			end


		otherwise
			error('Not a recognised termination condition, must be one of "minimised","no_change","n_runs"')
	end

	if flag
		SNOB.minimised = true;
	end

	if SNOB.ncall0 >= SNOB.ncall
		flag = 1;
		SNOB.minimised = false;
	end

end