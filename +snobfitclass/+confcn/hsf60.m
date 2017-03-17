function F = hsf60(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);

	F = x1.*(1 + x2.^2) + x3.^4 - 4 - 3*sqrt(2);

end