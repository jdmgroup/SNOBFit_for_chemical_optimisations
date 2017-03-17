function f = hsf65(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	f = (x1 - x2).^2 + (x1 + x2 - 10).^2/9 + (x3 - 5).^2;

end