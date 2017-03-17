function F = hsf41(f)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);

	F = x1 + 2.*x2 + 2.*x3 - x4;

end