function f = twoFun(SNOB)
	
	x = SNOB.next;

	f = (x(:,1) + 2).^2 + (x(:,2) + 3).^2;

end