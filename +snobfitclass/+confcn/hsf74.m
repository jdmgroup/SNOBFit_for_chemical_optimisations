function F = hsf74(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	x3 = SNOB.next(:,3);
	x4 = SNOB.next(:,4);

	a = 0.55;
	F(:,1) = x4 - x3 + a;
	F(:,2) = x3 - x4 + a;
	F(:,3) = 1000*sin(-x3 - 0.25) + 1000*sin(-x4 - 0.25) + 894.8 - x1;
	F(:,4) = 1000*sin(x3 - 0.25) + 1000*sin(x3 - x4 - 0.25) + 894.8 - x2; 
	F(:,5) = 1000*sin(x4 - 0.25) + 1000*sin(x4 - x3 - 0.25) + 1294.8;

end