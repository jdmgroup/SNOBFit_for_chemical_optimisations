% function f = sh5(SNOB)
% Shekel5 function
function f = sh5(SNOB)
	
	x = SNOB.next;
	n = size(x,1);

	a = [4.0d0, 1.0d0, 8.0d0, 6.0d0, 3.0d0;
	     4.0d0, 1.0d0, 8.0d0, 6.0d0, 7.0d0;
	     4.0d0, 1.0d0, 8.0d0, 6.0d0, 3.0d0;
	     4.0d0, 1.0d0, 8.0d0, 6.0d0, 7.0d0];
	c = [0.1d0, 0.2d0, 0.2d0, 0.4d0, 0.4d0];
	
	for i=1:n
		b = (repmat(x(i,:)',1,5) - a).^2;
		d(i,:) = sum(b);
	end
	
	f = -sum((repmat(c,n,1) + d).^(-1),2);

end
