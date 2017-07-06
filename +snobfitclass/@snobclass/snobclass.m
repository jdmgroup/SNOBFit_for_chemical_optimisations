classdef snobclass < handle

	properties (Hidden = true, SetAccess = private)
		fglob = 0;		% Expected global minimum of f
		xglob;		% Expected global minimisers
		uncert;		% Uncertainty in f
		xsoft;		% coordinates that satisfy soft condition and give best f
		fsoft;      % soft merit value at best feasible point
		next;		% next points to investigate
		created;	% date and time the experiment was created
		softstart = 0;	% number of calls after which soft method started (only applies to combo)
		f0 = Inf;
		Delta = Inf;
	end

	properties (Hidden= true,SetObservable, AbortSet)
		filepath;	% path to directory to save into
		xyMax;
		xyMin;
		maxRatio;
		minRatio;
		zMax;
		zMin;
		u;			% Lower Bounds of experiment parameters
		v;			% Upper Bounds of experiment parameters
	end

	properties (Hidden = true)%, SetAccess = ?snobfitclass.snobHandler)
		x;			% Points investigated
		f;			% Value of fcn at points investigated
		F;			% Value of soft fcn at points investigated
		fm;			% soft snobfit merit function
		xVirt;		% Virtual Points investigated (only for linked)
		n;			% Number of experiment parameters (dimension of problem)
		ncall0;		% Number times snobfit has been called
		dx;			% Resolution vector
		trapezoid;	% Trapezoid constraining parameters
	end

	properties (Hidden = true)
		file = 'oxcba3D';	% Working file for snobfit minimisation
		nreq;		% Number of points requested from snobfit
		p;
		npoint;		% Number of starting points
		threshold = 1e-3;	% threshold for terminating minimisation
		xstart;		% User defined starting point
		F1;			% Lower Bounds for soft constraint function
		F2;			% Upper Bounds for soft constraint function
		sigma;		% slope for soft merit function
		fbestHistory; % history of fbest for each call to snobfit
		ncallNoChange = 5; % number of same function values before terminating
		minCalls;	% minimum number of calls before terminating
		repeatBest = true; % option to repeat the measurement at fbest
		plot_delay = 0; % how long to pause between snobfit calls, for plotting
	end

	properties (SetObservable, AbortSet)
		name;		% Experiment name
		fcn;		% Target function for minimisation
		softfcn;	% Soft constraint function
		linked = false;	% User-defined constraints, x and y linked
		soft = false;		% Using soft snobfit or not
		continuing = false;	% If this is continuing an old file or not
		combo = false;		% if it is using a combination of soft and hard snobfit
	end

	properties (SetAccess = ?snobfitclass.snobHandler)
		status;		% experiment status - initialised, running, complete
		minimised;	% minimisation status
	end

	properties
		fbest;		% Lowest value of f so far
		xbest;		% Coordinates of lowest value so far
		ncall = 100;	% Limit of calls to snobfit
		termination = 'minimised' %
	end

	events
		DataToPlot;
		DataToPrint;
		StatusChange;
		StartingExp;
	end

	methods

		defaults(SNOB)
		startExp(SNOB)
		saveExp(SNOB)
		plotBounds(SNOB)
		runsnob(SNOB)
		runsoft(SNOB)
		runcombo(SNOB)

		function SNOB = snobclass(varargin)
			% Class constructor

			% parsing the input
			fcn_files = dir('+snobfitclass/+objfcn/*.m');
			fcn_list = cell(1,length(fcn_files));
			for i = 1:length(fcn_files)
				fcn_list{i} = fcn_files(i).name(1:end-2);
			end
			fcn_list{1,end+1} = 'none';		
			p = inputParser;
			p.addOptional('fcn','none',@(x) any(strcmp(x,fcn_list)));
			p.addOptional('continuing',false, @(x) islogical(x));
			p.addOptional('soft', false, @(x) islogical(x));
			p.addOptional('linked',false, @(x) islogical(x));
			p.addParamValue('name','untitled',@isstr);
			
			p.parse(varargin{:});
			settings = p.Results;

			SNOB.fcn = settings.fcn;
			SNOB.softfcn = SNOB.fcn;

			SNOB.uncert = 0.2;
			SNOB.p = 0.3;

			SNOB.created = datestr(now);

			% set default filepath
			if isunix
				SNOB.filepath = '~/Documents/MATLAB/SNOBFIT';
			else
				SNOB.filepath = ['C:\Users\', getenv('USERNAME'), '\Documents\MATLAB\SNOBFIT'];
			end

			snobfitclass.snobHandler.addOutput(SNOB);		% Add event listeners
			SNOB.defaults;

			SNOB.continuing = settings.continuing;

			if any(strcmp(varargin,'soft'))
				SNOB.soft = settings.soft;
			end

			if any(strcmp(varargin,'linked'))
				SNOB.linked = settings.linked;
			end

			if SNOB.soft
				SNOB.sigma = 0.05.*25.*ones(length(SNOB.F1),1);
			end

			SNOB.name = settings.name;
			SNOB.minCalls = ceil(SNOB.ncall/10);

		end

	end

end
