function f = hsf41(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	f = 2 - x1.*x2.*x3;

end