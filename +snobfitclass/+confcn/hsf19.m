function F = hsf19(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	F(:,1) = (x1 - 5).^2 + (x2 - 5).^2 - 100;
	F(:,2) = -(x2 - 5).^2 - (x1 - 6).^2 + 82.81;

end