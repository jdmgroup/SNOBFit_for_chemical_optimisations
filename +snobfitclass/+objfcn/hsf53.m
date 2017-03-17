function f = hsf53(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);
	x5 = SNOB.next(:,5);

	f = (x1 - x2).^2 + (x2 + x3 - 2).^2 + (x4 - 1).^2 + (x5 - 1).^2;

end