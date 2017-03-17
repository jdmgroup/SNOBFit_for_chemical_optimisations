function F = hsf71(SNOB)
	
	x = SNOB.next;
	
	F(:,1) = x(:,1).*x(:,2).*x(:,3).*x(:,4) - 25;
	F(:,2) = sum(x.^2,2) - 40;

end