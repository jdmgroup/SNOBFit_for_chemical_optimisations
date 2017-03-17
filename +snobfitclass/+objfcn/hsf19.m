function f = hsf19(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	f = (x1 - 10).^3 + (x2 - 20).^3;

end