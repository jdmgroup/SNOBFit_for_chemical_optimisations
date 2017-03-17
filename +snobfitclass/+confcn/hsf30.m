function F = hsF30(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	F = x1.^2 + x2.^2 - 1;

end
