function F = hsCon18(SNOB)

	addpath ~/Documents/MATLAB/v2.1/hsfun
	x = SNOB.next;
	F = zeros(length(x),2);

	for i = 1:length(x)
		F(i,:) = hsC18(x(i,:))';
	end

	addpath ~/Documents/MATLAB/v2.1/hsfun

end