% function f = gpr(SNOB)
% Goldstein-Price function
function f = gpr(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	f =(1+(x1+x2+1).^2.*(19-14.*x1+3.*x1.^2-14.*x2+6.*x1.*x2+3.*x2.^2))...
	.*(30+(2.*x1-3.*x2).^2.*(18-32.*x1+12.*x1.^2+48.*x2-36.*x1.*x2+27.*x2.^2));

end