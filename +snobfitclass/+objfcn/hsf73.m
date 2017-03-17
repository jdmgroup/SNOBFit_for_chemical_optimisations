function f = hsf73(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(;,4);

	f = 24.55*x1 + 26.75*x2 + 39*x3 + 40.5*x4;

end