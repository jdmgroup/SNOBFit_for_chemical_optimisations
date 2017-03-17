function F = hsf23(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	F(:,1) = x1 + x2 - 1;
	F(:,2) = x1.^2 + x2.^2 - 1;
	F(:,3) = 9*x1.^2 + x2.^2 - 9;
	F(:,4) = x1.^2 - x2;
	F(:,5) = x2.^2 - x1;

end