function F = hsf18(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	F(:,1) = x1.*x2 - 25;
	F(:,2) = x1.^2 + x2.^2 - 25;
end
