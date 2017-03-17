function F = hsf34(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	F(:,1) = x2 - exp(x1);
	F(:,2) = x3 - exp(x2);

end