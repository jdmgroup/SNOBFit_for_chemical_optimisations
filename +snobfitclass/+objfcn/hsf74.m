function f = hsf74(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	f = 3.*x1 + 1.e-6*x1.^3 + 2*x2 + 2/3*1.e-6*x2.^3;

end