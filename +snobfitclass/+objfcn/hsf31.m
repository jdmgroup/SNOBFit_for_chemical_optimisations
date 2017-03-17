function f = hsf31(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	f = 9*x1.^2 + x2.^2 + 9*x3.^2;

end