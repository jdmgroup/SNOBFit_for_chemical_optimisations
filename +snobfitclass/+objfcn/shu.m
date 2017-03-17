% function f = shu(SNOB)
% Shuberts function
function f = shu(SNOB)

	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);
	n = length(x1);

	sum1 = 0; 
	sum2 = 0;
	i = (1:5);
	a = i + 1;
	b = repmat(a,n,1);
	
	sum1 =sum(b.*cos(x1*a+b),2);
	sum2 = sum(b.*cos(x2*a+b),2);
	
	f = sum1.*sum2;

end
