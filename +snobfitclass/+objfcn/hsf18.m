function f = hsf18(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	
	f = 0.01*x1.^2 + x2.^2;

end