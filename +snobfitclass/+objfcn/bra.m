% function f = bra(SNOB)
% Branins function
function f = bra(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	a=1;
	b=5.1/(4*pi^2);
	c=5/pi;
	d=6;
	h=10;
	ff=1/(8*pi);
	f=a.*(x2 - b.*x1.^2 + c.*x1 - d).^2 + h.*(1 - ff).*cos(x1)+h;

end
