% function f = cam(SNOB)
% Four-hump camel
function f = cam(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	f=(4-2.1.*x1.^2+x1.^4./3).*x1.^2+x1.*x2+(-4+4.*x2.^2).*x2.^2;        

end
