% function f = sh7(SNOB)
% Shekel7 function
function f = sh7(SNOB)
	
	x = SNOB.next;
	n = size(x,1);

	a = [4, 1, 8, 6, 3, 2, 5;
	     4, 1, 8, 6, 7, 9, 5;
	     4, 1, 8, 6, 3, 2, 3;
	     4, 1, 8, 6, 7, 9, 3];
	c = [0.1 0.2 0.2 0.4 0.4 0.6 0.3];
	
	for i=1:n
		b = (repmat(x(i,:)',1,7) - a).^2;
		d(i,:) = sum(b);
	end
	
	f = -sum((repmat(c,n,1) + d).^(-1),2);

end
