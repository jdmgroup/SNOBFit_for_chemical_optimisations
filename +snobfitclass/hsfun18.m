function f = hsfun18(SNOB)

	addpath ~/Documents/MATLAB/v2.1/hsfun
	x = SNOB.next;
	f = zeros(length(x),1);

	for i = 1:length(x)
		f(i) = hsf18(x(i,:));
	end

	addpath ~/Documents/MATLAB/v2.1/hsfun

end