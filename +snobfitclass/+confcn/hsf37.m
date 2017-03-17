function F = hsf37(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	F(:,1) = 72 - x1 - 2.*x2 - 2.*x3;
	F(:,2) = x1 + 2.*x2 + 2.*x3;

end
