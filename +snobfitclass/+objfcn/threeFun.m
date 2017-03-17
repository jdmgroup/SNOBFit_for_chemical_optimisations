function f = threeFun(SNOB)

	x = SNOB.next;

	f = (x(:,1) + 2).^2 + (x(:,2) + 3).^2 + (x(:,3) - 1).^2;

end