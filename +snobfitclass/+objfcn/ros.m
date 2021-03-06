%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ros.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function f = ros(SNOB)
% Rosenbrocks function
function f = ros(SNOB)
	
	x1 = SNOB.next(:,1);
	x2 = SNOB.next(:,2);

	f = 100*(x1.^2 - x2).^2 + (x1 - 1).^2;

end
