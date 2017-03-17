function f = hsf60(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	f = (x1 - 1).^2 + (x1 - x2).^2 + (x2 - x3).^4;

end