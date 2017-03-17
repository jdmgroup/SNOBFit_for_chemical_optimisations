function F = hsf73(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);

	F(:,1) = 2.3*x1 + 5.6*x2 + 11.1*x3 + 1.3*x4 - 5;
	F(:,2) = 12*x1 + 11.9*x2 + 41.8*x3 + 52.1*x4 - 21 - 1.645*sqrt(.28*x1.^2 + .19*x2.^2 + 20.5*x3.^2 + .62*x4.^2);
	F(:,3) = x1 + x2 + x3 + x4 - 1;

end
