function F = hsf53(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);
	x5 = SNOB.next(:,5);

	F(:,1) = x1 + 3.*x2;
	F(:,2) = x3 + x4 - 2.*x5;
	F(:,3) = x2 - x5;

end