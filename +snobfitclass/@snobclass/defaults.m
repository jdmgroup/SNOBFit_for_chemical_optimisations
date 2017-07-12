function SNOB = defaults(SNOB)

	switch SNOB.fcn

		case 'gpr'
			SNOB.linked = false;
			SNOB.u = [-2;-2];
			SNOB.v = [2;2];
			SNOB.fglob = 3;
			SNOB.xglob = [0.;-1.];

		case 'bra'
			SNOB.linked = false;
			SNOB.u = [-5;0];
			SNOB.v = [10;15];
			SNOB.fglob = 0.397887357729739;
			SNOB.xglob = [9.42477796, -3.14159265, 3.14159265; 2.47499998, 12.27500000, 2.27500000];

		case 'cam'
			SNOB.linked = false;
			SNOB.u = [-3;-2];
			SNOB.v = [3;2];
			SNOB.fglob = -1.0316284535;
			SNOB.xglob = [0.08984201, -0.08984201; -0.71265640, 0.71265640];

		case 'shu'
			SNOB.linked = false;
			SNOB.u = [-10;-10];
			SNOB.v = [10;10];
			SNOB.fglob = -186.730908831024;
			SNOB.xglob = [-7.08350658  5.48286415  4.85805691  4.85805691 -7.08350658 -7.70831382 -1.42512845 -0.80032121 -1.42512844 -7.08350639 -7.70831354  5.48286415  5.48286415  4.85805691 -7.70831354 -0.80032121 -1.42512845 -0.80032121; 
							4.85805691  4.85805681 -7.08350658  5.48286415 -7.70831382 -7.08350658 -0.80032121 -1.42512845 -7.08350639 -1.42512844  5.48286415 -7.70831354  4.85805691  5.48286415 -0.80032121 -7.70831354 -0.80032121 -1.42512845];

		case 'sh5'
			SNOB.linked = false;
			SNOB.u = zeros(4,1);
			SNOB.v = 10.*ones(4,1);
			SNOB.fglob = -10.1531996790582;
			SNOB.xglob = [4; 4; 4; 4];

		case 'sh7'
			SNOB.linked = false;
			SNOB.u = zeros(4,1);
			SNOB.v = 10.*ones(4,1);
			SNOB.fglob = -10.4029405668187;
			SNOB.xglob = [4; 4; 4; 4];

		case 'sh10'
			SNOB.linked = false;
			SNOB.u = zeros(4,1);
			SNOB.v = 10.*ones(4,1);
			SNOB.fglob = -10.5364098166920;
			SNOB.xglob = [4; 4; 4; 4];

		case 'hm3'
			SNOB.linked = false;
			SNOB.u = zeros(3,1);
			SNOB.v = ones(3,1);
			SNOB.fglob = -3.86278214782076;
			SNOB.xglob = [0.1; 0.55592003; 0.85218259];

		case 'hm6'
			SNOB.linked = false;
			SNOB.u = zeros(6,1);
			SNOB.v = ones(6,1);
			SNOB.fglob = -3.32236801141551;
			SNOB.xglob = [0.20168952;  0.15001069;  0.47687398; 0.27533243;  0.31165162;  0.65730054];

		case 'ros'
			SNOB.linked = false;
			SNOB.u = -5.12.*ones(2,1);
			SNOB.v = -SNOB.u;
			SNOB.fglob = 0;
			SNOB.xglob = [1; 1];

		case 'twoFun'	% Quadratic function with two parameters
			SNOB.linked = false;
			SNOB.u = [-5; -5];
			SNOB.v = [5; 5];
			SNOB.fglob = 0;
			SNOB.xglob = [-2; -3];

		case 'threeFun'		% Quadratic function with three parameters
			SNOB.linked = false;
			SNOB.u = [-5; -5; -2];
			SNOB.v = [5; 5; 2];
			SNOB.fglob = 0;
			SNOB.xglob = [-2; -3; 1];

		case 'oxcbaReactor2D'
			SNOB.linked = true;
			SNOB.xyMax = 922;
			SNOB.xyMin = 61;
			SNOB.maxRatio = 4;
			SNOB.minRatio = 1/4;
			SNOB.zMax = 100;	% Use this to set the temperature
			SNOB.fglob = 0;

		case 'oxcbaReactor3D'
			SNOB.linked = true;
			SNOB.xyMax = 922;
			SNOB.xyMin = 61;
			SNOB.maxRatio = 4;
			SNOB.minRatio = 1/4;
			SNOB.zMin = 80;
			SNOB.zMax = 180;
			SNOB.fglob = 0;

		case 'hsF_lower8'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [2; 0];
			SNOB.v = [50; 50];
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; Inf];
			SNOB.xstart = [2, 2];
			SNOB.fglob = 5;
			SNOB.xglob = [sqrt(250); sqrt(2.5)];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsF_lower9'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [13; 0];
			SNOB.v = [100; 100];
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; Inf];
			SNOB.xstart = [20.1, 5.84];
			SNOB.fglob = -6961.81381;
			SNOB.xglob = [14.095; 0.84296079];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsF_upper3'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [-50; -50];
			SNOB.v = [50; 50];
			SNOB.F_lower = zeros(5,1);
			SNOB.F_upper = Inf*ones(5,1);
			SNOB.xstart = [3, 1];
			SNOB.fglob = 2;
			SNOB.xglob = [1; 1];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;			

		case 'hsf30'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [1; -10; -10];
			SNOB.v = [10; 10; 10];
			SNOB.F_lower = 0;
			SNOB.F_upper = Inf;
			SNOB.xstart = [1, 1, 1];
			SNOB.fglob = 1;
			SNOB.xglob = [1; 0; 0];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf31'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [-10; 1; -10];
			SNOB.v = [10; 10; 1];
			SNOB.F_lower = 0;
			SNOB.F_upper = Inf;
			SNOB.xstart = [1, 1, 1];
			SNOB.fglob = 6;
			SNOB.xglob = [1/sqrt(3); sqrt(3); 0];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf34'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [0; 0; 0];
			SNOB.v = [100; 100; 10];
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; Inf];
			SNOB.xstart = [0, 1.05, 2.9];
			SNOB.fglob = -log(log(10));
			SNOB.xglob = [log(log(10)); log(10); 10];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf36'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [0; 0; 0];
			SNOB.v = [20; 11; 42];
			SNOB.F_lower = 0;
			SNOB.F_upper = Inf;
			SNOB.xstart = [10, 10, 10];
			SNOB.fglob = -3300;
			SNOB.xglob = [20; 11; 15];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf37'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [0; 0; 0];
			SNOB.v = [42; 42; 42];
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; Inf];
			SNOB.xstart = [10, 10, 10];
			SNOB.fglob = -3456;
			SNOB.xglob = [24; 12; 12];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf41'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = zeros(4,1);
			SNOB.v = [ones(3,1); 2];
			SNOB.F_lower = 0;
			SNOB.F_upper = 0;
			SNOB.xstart = [2, 2, 2, 2];
			SNOB.fglob = 52/27;
			SNOB.xglob = [2/3; 1/3; 1/3; 2];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf53'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = -10*ones(5,1);
			SNOB.v = 10*ones(5,1);
			SNOB.F_lower = zeros(3,1);
			SNOB.F_upper = zeros(3,1);
			SNOB.xstart = [2, 2, 2, 2, 2];
			SNOB.fglob = 176/43;
			SNOB.xglob = [-33; 11; 27; -5; 11]/43;
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf60'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = -10*ones(3,1);
			SNOB.v = 10*ones(3,1);
			SNOB.F_lower = 0;
			SNOB.F_upper = 0;
			SNOB.xstart = [2, 2, 2];
			SNOB.fglob = 0.03256820025;
			SNOB.xglob = [1.104859024; 1.196674194; 1.535262257];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf65'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = [-4.5; -4.5; -5];
			SNOB.v = [4.5; 4.5; 5];
			SNOB.F_lower = 0;
			SNOB.F_upper = Inf;
			SNOB.xstart = [-5, 5, 0];
			SNOB.fglob = 0.9535288567;
			SNOB.xglob = [3.650461821; 3.65046169; 4.6204170507];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf66'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = zeros(3,1);
			SNOB.v = [100; 100; 10];
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; Inf];
			SNOB.xstart = [0, 1.05, 2.9];
			SNOB.fglob = 0.5181632741;
			SNOB.xglob = [0.1841264879; 1.202167873; 3.327322322];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf71'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = zeros(4,1);
			SNOB.v = 5*ones(4,1);
			SNOB.F_lower = [0; 0];
			SNOB.F_upper = [Inf; 0];
			SNOB.xstart = [1, 5, 5, 1];
			SNOB.fglob = 17.0140173;
			SNOB.xglob = [1; 4.7429994; 3.8211503; 1.3794082];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf73'
			SNOB.linked = false;
			SNOB.soft = true;
			SNOB.u = zeros(4,1);
			SNOB.v = Inf*ones(4,1);
			SNOB.F_lower = zeros(3,1);
			SNOB.F_upper = [Inf; Inf; 0];
			SNOB.xstart = [1, 1, 1, 1];
			SNOB.fglob = 130.8;
			SNOB.xglob = [0.6355216; -0.12e-11; 0.3127019; 0.05177655];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'hsf74'
			SNOB.linked = false;
			SNOB.soft = true;
			a = 0.55;
			SNOB.u = [0; 0; -a; -a];
			SNOB.v = [1200; 1200; a; a];
			SNOB.F_lower = zeros(5,1);
			SNOB.F_upper = [Inf; Inf; zeros(3,1)];
			SNOB.xstart = zeros(1,4);
			SNOB.fglob = 5126.4981;
			SNOB.xglob = [679.9453; 1026.067; 0.1188764; -0.3962336];
			SNOB.ncall = 10000;
			SNOB.p = 0.5;

		case 'test_oxcba'
			SNOB.linked = true;
			SNOB.xyMax = 310;
			SNOB.xyMin = 92.2;
			SNOB.maxRatio = 2;
			SNOB.minRatio = 1/2;
			SNOB.zMin = 100;
			SNOB.zMax = 150;
			SNOB.fglob = 0;

		case 'none'
			disp('User must enter function and setup values!')
			
		otherwise
			disp('User must enter setup values!')
	end

end