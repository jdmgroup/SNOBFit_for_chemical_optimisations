function plotOut(SNOB)
	if SNOB.ncall0 == SNOB.npoint
		figure;
	end

	if SNOB.feasiblePointFound
		best_marker = 'rx';
	else
		best_marker = 'kx';
	end

	if SNOB.linked
		subplot(1,3,1);
		scatter(SNOB.x(:,1),SNOB.x(:,2),50,abs(SNOB.fglob - SNOB.f));
		set(gca,'box','on');
		title(['Real Space - ',num2str(SNOB.ncall0),' Function Calls'])
		xlabel('x');
		ylabel('y');

		SNOB.plotBounds;

		subplot(1,3,2);
		scatter(SNOB.xVirt(:,1),SNOB.xVirt(:,2),50,abs(SNOB.fglob - SNOB.f));
		set(gca,'box','on');
		title(['Virtual Space - ',num2str(SNOB.ncall0),' Function Calls']);
		xlabel('x');
		ylabel('y');

		subplot(1,3,3);
		plot(SNOB.ncall0,SNOB.fbest,best_marker,'MarkerSize',5,'LineWidth',2);
		xlabel('Number of function calls');
		ylabel('fbest');
		hold on;
	else
		subplot(1,2,1);
		scatter(SNOB.x(:,1),SNOB.x(:,2),50,abs(SNOB.fglob - SNOB.f));
		set(gca,'box','on');
		title(['Real Space - ',num2str(SNOB.ncall0),' Function Calls'])
		xlabel('x');
		ylabel('y');

		subplot(1,2,2);
		plot(SNOB.ncall0,SNOB.fbest,best_marker,'MarkerSize',5,'LineWidth',2);
		xlabel('Number of function calls');
		ylabel('fbest');
		hold on;
	end

end
