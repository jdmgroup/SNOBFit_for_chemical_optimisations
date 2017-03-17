function f = hartman6(SNOB)
	
	addpath ~/Documents/MATLAB/v2.1/testfun
	
	f = zeros(length(SNOB.next),1);

	for i = 1:length(SNOB.next)
		x = SNOB.next(i,:);
		f(i) = hm6(x);
	end

	rmpath ~/Documents/MATLAB/v2.1/testfun

end
