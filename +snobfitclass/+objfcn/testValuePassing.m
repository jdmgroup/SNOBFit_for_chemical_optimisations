function f = testValuePassing(SNOB)

    x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	
    SNOB.valuesToPass(:,1) = x1.*x2 - 25;;
    SNOB.valuesToPass(:,2) = x1.^2 + x2.^2 - 25;

	f = 0.01*x1.^2 + x2.^2;


end