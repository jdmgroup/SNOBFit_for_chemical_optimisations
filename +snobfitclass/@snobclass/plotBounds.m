function plotBounds(SNOB)

	if SNOB.linked

	[~,v1_i] = min(SNOB.trapezoid(1,:));
	[~,v2_i] = min(SNOB.trapezoid(2,:));
	[~,v3_i] = max(SNOB.trapezoid(1,:));
	[~,v4_i] = max(SNOB.trapezoid(2,:));

	v1 = SNOB.trapezoid(:,v1_i);
	v2 = SNOB.trapezoid(:,v2_i);
	v3 = SNOB.trapezoid(:,v3_i);
	v4 = SNOB.trapezoid(:,v4_i);
		if SNOB.n == 3
			line([v1(1), v1(1)], [v1(2), v1(2)],[SNOB.zMin, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v2(1), v2(1)], [v2(2), v2(2)],[SNOB.zMin, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v3(1), v3(1)], [v3(2), v3(2)],[SNOB.zMin, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v4(1), v4(1)], [v4(2), v4(2)],[SNOB.zMin, SNOB.zMax],'LineStyle',':', 'Color', 'k');

			line([v1(1), v2(1)], [v1(2), v2(2)],[SNOB.zMax, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v2(1), v3(1)], [v2(2), v3(2)],[SNOB.zMax, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v3(1), v4(1)], [v3(2), v4(2)],[SNOB.zMax, SNOB.zMax],'LineStyle',':', 'Color', 'k');
			line([v4(1), v1(1)], [v4(2), v1(2)],[SNOB.zMax, SNOB.zMax],'LineStyle',':', 'Color', 'k');

			line([v1(1), v2(1)], [v1(2), v2(2)],[SNOB.zMin, SNOB.zMin],'LineStyle',':', 'Color', 'k');
			line([v2(1), v3(1)], [v2(2), v3(2)],[SNOB.zMin, SNOB.zMin],'LineStyle',':', 'Color', 'k');
			line([v3(1), v4(1)], [v3(2), v4(2)],[SNOB.zMin, SNOB.zMin],'LineStyle',':', 'Color', 'k');
			line([v4(1), v1(1)], [v4(2), v1(2)],[SNOB.zMin, SNOB.zMin],'LineStyle',':', 'Color', 'k');

			xlabel('x1')
			ylabel('x2')
			zlabel('x3')
		else
			line([v1(1), v2(1)], [v1(2), v2(2)], 'LineStyle',':', 'Color', 'k');
			line([v2(1), v3(1)], [v2(2), v3(2)], 'LineStyle',':', 'Color', 'k');
			line([v3(1), v4(1)], [v3(2), v4(2)], 'LineStyle',':', 'Color', 'k');
			line([v4(1), v1(1)], [v4(2), v1(2)], 'LineStyle',':', 'Color', 'k');

			xlabel('x1')
			ylabel('x2')
		end
	else

		if SNOB.n >= 3

			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_lower(2)],[SNOB.x_lower(3), SNOB.x_lower(3)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_lower(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],[SNOB.x_lower(3), SNOB.x_lower(3)],'LineStyle',':','Color','k');
			line([SNOB.x_upper(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],[SNOB.x_lower(3), SNOB.x_lower(3)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_upper(2), SNOB.x_upper(2)],[SNOB.x_lower(3), SNOB.x_lower(3)],'LineStyle',':','Color','k');

			line([SNOB.x_lower(1), SNOB.x_lower(1)],[SNOB.x_lower(2), SNOB.x_lower(2)],[SNOB.x_lower(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_lower(1)],[SNOB.x_upper(2), SNOB.x_upper(2)],[SNOB.x_lower(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_upper(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_lower(2)],[SNOB.x_lower(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_upper(1), SNOB.x_upper(1)],[SNOB.x_upper(2), SNOB.x_upper(2)],[SNOB.x_lower(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');

			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_lower(2)],[SNOB.x_upper(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_lower(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],[SNOB.x_upper(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_upper(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],[SNOB.x_upper(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_upper(2), SNOB.x_upper(2)],[SNOB.x_upper(3), SNOB.x_upper(3)],'LineStyle',':','Color','k');

			xlabel('x1')
			ylabel('x2')
			zlabel('x3')

			axis([SNOB.x_lower(1)-0.5 SNOB.x_upper(1)+0.5 SNOB.x_lower(2)-0.5 SNOB.x_upper(2)+0.5 SNOB.x_lower(3)-0.5 SNOB.x_upper(3)+0.5])

			if SNOB.n > 3
				warning('too many dimensions: only plotted first 3')
			end
		else
			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_lower(2)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_lower(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],'LineStyle',':','Color','k');
			line([SNOB.x_upper(1), SNOB.x_upper(1)],[SNOB.x_lower(2), SNOB.x_upper(2)],'LineStyle',':','Color','k');
			line([SNOB.x_lower(1), SNOB.x_upper(1)],[SNOB.x_upper(2), SNOB.x_upper(2)],'LineStyle',':','Color','k');

			xlabel('x1')
			ylabel('x2')

			axis([SNOB.x_lower(1)-0.5 SNOB.x_upper(1)+0.5 SNOB.x_lower(2)-0.5 SNOB.x_upper(2)+0.5])
		end
	end

end