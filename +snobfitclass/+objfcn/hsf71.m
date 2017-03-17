function f = hsf71(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);

	f = x1.*x4.*(x1 + x2 + x3) + x3;

end